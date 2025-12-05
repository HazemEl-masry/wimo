import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wimo/core/services/token_service.dart';

/// Production-ready Token Refresh Interceptor
///
/// Features:
/// - Separate Dio instance for refresh requests (prevents circular dependency)
/// - Completer-based request queueing for concurrent 401 responses
/// - Response validation before saving tokens
/// - Debug logging for monitoring
/// - Automatic logout on refresh failure
///
/// How it works:
/// 1. Detects 401 Unauthorized responses
/// 2. Queues concurrent requests using Completer
/// 3. Makes refresh request using CLEAN Dio instance (no interceptors)
/// 4. Saves new tokens and retries all queued requests
/// 5. Triggers logout if refresh fails
class RefreshTokenInterceptor extends Interceptor {
  final Dio dio; // Main Dio instance (with interceptors)
  final TokenService tokenService;
  final String baseUrl;
  final void Function() onRefreshFailed;

  // Separate Dio instance for refresh requests ONLY (no interceptors)
  late final Dio _refreshDio;

  // Concurrency control
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  RefreshTokenInterceptor({
    required this.dio,
    required this.tokenService,
    required this.baseUrl,
    required this.onRefreshFailed,
  }) {
    // Create a CLEAN Dio instance without any interceptors
    // This prevents the circular dependency issue where the refresh request
    // would go through the token injection interceptor
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Optional: Add logging to refresh Dio for debugging
    if (kDebugMode) {
      _refreshDio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('🔄 [REFRESH]: $obj'),
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors (expired access token)
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Prevent infinite loop: if refresh endpoint itself returns 401, don't retry
    if (err.requestOptions.path.contains('auth/refresh-token')) {
      _logDebug('❌ Refresh endpoint returned 401 - token invalid');
      return handler.next(err);
    }

    _logDebug('🔒 401 detected for: ${err.requestOptions.path}');

    try {
      // If refresh is already in progress, wait for it to complete
      if (_isRefreshing) {
        _logDebug(
          '⏳ Request queued (refresh in progress): ${err.requestOptions.path}',
        );

        // Wait for the ongoing refresh to complete
        await _refreshCompleter?.future;

        _logDebug(
          '✅ Refresh completed, retrying queued request: ${err.requestOptions.path}',
        );

        // After refresh completes, retry the original request with new token
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      }

      // Start refresh process
      _logDebug('🔄 Starting token refresh...');
      _isRefreshing = true;
      _refreshCompleter = Completer<void>();

      // Get refresh token from secure storage
      final refreshToken = await tokenService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw RefreshTokenException('No refresh token available');
      }

      _logDebug('📤 Calling refresh endpoint...');

      // Call refresh token endpoint using CLEAN Dio instance
      // This instance has NO interceptors, so no token will be auto-injected
      final response = await _refreshDio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      _logDebug('📥 Refresh response received: ${response.statusCode}');

      // Validate response structure before proceeding
      _validateRefreshResponse(response);

      // Extract new tokens from validated response
      final data = response.data['data'] as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;
      final userId = data['userId'] as String? ?? '';

      _logDebug('💾 Saving new tokens to secure storage...');

      // Save new tokens to secure storage
      await tokenService.saveAuthData(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        userId: userId,
      );

      _logDebug('✅ Tokens saved successfully');

      // Mark refresh as complete (releases all waiting requests)
      _refreshCompleter?.complete();
      _isRefreshing = false;
      _refreshCompleter = null;

      _logDebug('🔁 Retrying original request: ${err.requestOptions.path}');

      // Retry the original failed request with new token
      final retryResponse = await _retry(err.requestOptions);

      _logDebug('✅ Original request succeeded');

      return handler.resolve(retryResponse);
    } on RefreshTokenException catch (e) {
      // Known refresh errors
      await _handleRefreshFailure(e.message);
      return handler.next(err);
    } on DioException catch (e) {
      // Dio errors (network, timeout, etc.)
      await _handleRefreshFailure('Network error during refresh: ${e.message}');
      return handler.next(err);
    } catch (e) {
      // Unexpected errors
      await _handleRefreshFailure('Unexpected error: $e');
      return handler.next(err);
    }
  }

  /// Validate refresh response structure
  void _validateRefreshResponse(Response response) {
    if (response.data == null) {
      throw RefreshTokenException('Refresh response is null');
    }

    if (response.data is! Map) {
      throw RefreshTokenException('Refresh response is not a map');
    }

    final data = response.data['data'];
    if (data == null) {
      throw RefreshTokenException('Missing "data" field in refresh response');
    }

    if (data is! Map) {
      throw RefreshTokenException('"data" field is not a map');
    }

    // Validate required fields
    if (data['accessToken'] == null || data['accessToken'].toString().isEmpty) {
      throw RefreshTokenException('Missing or empty accessToken in response');
    }

    if (data['refreshToken'] == null ||
        data['refreshToken'].toString().isEmpty) {
      throw RefreshTokenException('Missing or empty refreshToken in response');
    }

    _logDebug('✅ Refresh response validated');
  }

  /// Handle refresh failure - cleanup and trigger logout
  Future<void> _handleRefreshFailure(String reason) async {
    _logDebug('❌ Refresh failed: $reason');

    // Complete completer with error to release waiting requests
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _refreshCompleter?.completeError(RefreshTokenException(reason));
    }

    _isRefreshing = false;
    _refreshCompleter = null;

    // Clear all tokens from secure storage
    await tokenService.clearTokens();

    _logDebug('🚪 Triggering logout...');

    // Trigger logout callback (navigate to auth screen)
    onRefreshFailed();
  }

  /// Retry a request with the current (refreshed) access token
  Future<Response> _retry(RequestOptions requestOptions) async {
    // Get the new access token from storage
    final token = await tokenService.getAccessToken();

    // Create new options with updated authorization header
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

    // Retry the request using main Dio instance
    // This will go through all interceptors normally
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Log debug messages (only in debug mode)
  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('🔐 [TokenRefresh] $message');
    }
  }

  /// Cleanup when interceptor is disposed
  void dispose() {
    _refreshDio.close();
  }
}

/// Custom exception for refresh token errors
class RefreshTokenException implements Exception {
  final String message;

  RefreshTokenException(this.message);

  @override
  String toString() => 'RefreshTokenException: $message';
}
