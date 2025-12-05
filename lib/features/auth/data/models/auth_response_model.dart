import 'package:wimo/core/models/user_model.dart';

class AuthResponse {
  final bool success;
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String? message;

  AuthResponse({
    required this.success,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? true,
      user: UserModel.fromJson(json['data']['user']),
      accessToken: json['data']['accessToken'],
      refreshToken: json['data']['refreshToken'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': {
        'user': user.toJson(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
      'message': message,
    };
  }
}

class SendOtpResponse {
  final bool success;
  final String phone;
  final String? message;

  SendOtpResponse({required this.success, required this.phone, this.message});

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] ?? true,
      phone: json['data']['phone'] ?? json['phone'] ?? '',
      message: json['message'],
    );
  }
}
