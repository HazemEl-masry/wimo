part of 'auth_phone_cubit.dart';

abstract class AuthPhoneState extends Equatable {
  const AuthPhoneState();

  @override
  List<Object> get props => [];
}

class AuthPhoneInitial extends AuthPhoneState {}

class AuthPhoneLoading extends AuthPhoneState {}

class AuthPhoneSuccess extends AuthPhoneState {
  final String phone;

  const AuthPhoneSuccess({required this.phone});

  @override
  List<Object> get props => [phone];
}

class AuthPhoneError extends AuthPhoneState {
  final String errorMessage;

  const AuthPhoneError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
