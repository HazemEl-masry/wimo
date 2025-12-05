class AuthEntityPhone {
  final String phone;

  AuthEntityPhone({required this.phone});
}

class AuthEntityOtp {
  final String phone;
  final String otp;

  AuthEntityOtp({required this.phone, required this.otp});
}

class AuthEntityResponse {
  final String userId;
  final String phone;
  final String accessToken;
  final String refreshToken;

  AuthEntityResponse({
    required this.userId,
    required this.phone,
    required this.accessToken,
    required this.refreshToken,
  });
}
