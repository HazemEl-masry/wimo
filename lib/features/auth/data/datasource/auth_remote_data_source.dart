import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModelPhone> sendOtp({required String phone});
  Future<AuthModelOtp> verifyOtp({required String phone, required String otp});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiServices apiServices;

  AuthRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<AuthModelPhone> sendOtp({required String phone}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'auth/send-otp',
        data: {'phone': phone},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response structures
        if (response.data is Map<String, dynamic>) {
          // If response has data, use it; otherwise create model with sent phone
          final phoneFromResponse = response.data['phone'] ?? phone;
          return AuthModelPhone(phoneNumber: phoneFromResponse);
        } else {
          // If response is not a map, just return the phone we sent
          return AuthModelPhone(phoneNumber: phone);
        }
      } else {
        throw Exception('Failed to send OTP: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<AuthModelOtp> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'auth/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response structures
        if (response.data is Map<String, dynamic>) {
          final phoneFromResponse = response.data['phone'] ?? phone;
          final otpFromResponse = response.data['otp'] ?? otp;
          return AuthModelOtp(
            phoneNumber: phoneFromResponse,
            otpVerification: otpFromResponse,
          );
        } else {
          // If response is not a map, use the data we sent
          return AuthModelOtp(phoneNumber: phone, otpVerification: otp);
        }
      } else {
        throw Exception('Failed to verify OTP: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }
}
