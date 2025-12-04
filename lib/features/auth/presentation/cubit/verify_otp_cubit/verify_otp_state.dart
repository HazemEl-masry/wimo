part of 'verify_otp_cubit.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final String phone;
  final String otp;

  const VerifyOtpSuccess({required this.phone, required this.otp});

  @override
  List<Object> get props => [phone, otp];
}

class VerifyOtpError extends VerifyOtpState {
  final String errorMessage;

  const VerifyOtpError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
