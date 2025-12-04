import 'package:dio/dio.dart';

class ApiServices {
  final Dio dio;
  final String baseUrl = "http://192.168.1.5:3000";
  ApiServices({required this.dio});
  Future<Response> postRequest({
    required String endPoint,
    required Object? data,
  }) async {
    final response = await dio.post("$baseUrl/$endPoint", data: data);
    return response;
  }
}
