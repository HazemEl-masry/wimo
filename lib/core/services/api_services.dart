import 'package:dio/dio.dart';
import 'package:wimo/core/services/token_service.dart';

class ApiServices {
  final Dio dio;
  final TokenService? tokenService;
  final String baseUrl = "http://192.168.1.5:3000/";

  ApiServices({required this.dio, this.tokenService}) {
    // Configure dio with default options
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers['Content-Type'] = 'application/json';

    // Add interceptor to automatically inject token
    if (tokenService != null) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Automatically inject token before each request
            final token = await tokenService!.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
          onError: (error, handler) async {
            // If we get 401, try to handle it gracefully
            if (error.response?.statusCode == 401) {
              // Token might be expired - could implement refresh logic here
              // For now, just pass the error through
            }
            handler.next(error);
          },
        ),
      );
    }
  }

  /// Set authentication token for all requests
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authentication token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  /// Check if authentication token is set
  bool hasAuthToken() {
    return dio.options.headers.containsKey('Authorization');
  }

  /// Get current auth token from headers (for debugging)
  String? getCurrentAuthToken() {
    final authHeader = dio.options.headers['Authorization'];
    if (authHeader is String && authHeader.startsWith('Bearer ')) {
      return authHeader.substring(7);
    }
    return null;
  }

  /// POST request
  Future<Response> postRequest({
    required String endPoint,
    required Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        data: data,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GET request
  Future<Response> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patchRequest({
    required String endPoint,
    required Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.patch(
        endPoint,
        data: data,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> deleteRequest({
    required String endPoint,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.delete(
        endPoint,
        data: data,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> putRequest({
    required String endPoint,
    required Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.put(
        endPoint,
        data: data,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file with multipart/form-data
  Future<Response> uploadFile({
    required String endPoint,
    required FormData formData,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data', ...?headers},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to meaningful exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['error'] ??
            error.response?.data?['message'] ??
            'Request failed';

        switch (statusCode) {
          case 400:
            return Exception('Bad request: $message');
          case 401:
            return Exception(
              'Unauthorized: Invalid or expired token. Please log in again.',
            );
          case 403:
            return Exception('Forbidden: $message');
          case 404:
            return Exception('Not found: $message');
          case 500:
            return Exception('Server error: $message');
          default:
            return Exception(
              'Request failed with status $statusCode: $message',
            );
        }

      case DioExceptionType.cancel:
        return Exception('Request cancelled');

      case DioExceptionType.connectionError:
        return Exception('No internet connection');

      default:
        return Exception('Network error: ${error.message}');
    }
  }
}
