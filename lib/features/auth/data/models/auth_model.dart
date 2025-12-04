import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';

class AuthModelPhone extends AuthEntityPhone {
  final String phoneNumber;

  AuthModelPhone({required this.phoneNumber}) : super(phone: phoneNumber);

  factory AuthModelPhone.fromJson(Map<String, dynamic> json) {
    return AuthModelPhone(phoneNumber: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'phone': phoneNumber};
  }
}

class AuthModelOtp extends AuthEntityOtp {
  final String phoneNumber;
  final String otpVerification;

  AuthModelOtp({required this.phoneNumber, required this.otpVerification})
    : super(phone: phoneNumber, otp: otpVerification);

  factory AuthModelOtp.fromJson(Map<String, dynamic> json) {
    return AuthModelOtp(
      phoneNumber: json['phone'],
      otpVerification: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'phone': phoneNumber, 'otp': otpVerification};
  }
}
