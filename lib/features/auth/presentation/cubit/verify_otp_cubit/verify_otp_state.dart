part of 'verify_otp_cubit.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final String userId;
  final String phone;
  final String accessToken;

  const VerifyOtpSuccess({
    required this.userId,
    required this.phone,
    required this.accessToken,
  });

  @override
  List<Object> get props => [userId, phone, accessToken];
}

class VerifyOtpError extends VerifyOtpState {
  final String errorMessage;

  const VerifyOtpError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
