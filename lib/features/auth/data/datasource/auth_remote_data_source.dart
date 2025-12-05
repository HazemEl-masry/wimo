import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<SendOtpResponse> sendOtp({required String phone});
  Future<AuthResponse> verifyOtp({required String phone, required String otp});
  Future<AuthResponse> refreshToken({required String refreshToken});
  Future<void> logout({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiServices apiServices;

  AuthRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<SendOtpResponse> sendOtp({required String phone}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'auth/send-otp',
        data: {'phone': phone},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendOtpResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to send OTP: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'auth/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to verify OTP: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponse> refreshToken({required String refreshToken}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to refresh token: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: ${e.toString()}');
    }
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'auth/logout',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to logout: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }
}
