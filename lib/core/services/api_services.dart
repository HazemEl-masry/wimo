import 'package:dio/dio.dart';

class ApiServices {
  final Dio dio;
  final String baseUrl = "http://192.168.1.5:3000/";

  ApiServices({required this.dio}) {
    // Configure dio with default options
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers['Content-Type'] = 'application/json';
  }

  /// Set authentication token for all requests
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authentication token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
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
            return Exception('Unauthorized: $message');
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
