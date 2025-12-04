import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/features/auth/domain/usecases/send_otp_usecase.dart';

part 'auth_phone_state.dart';

class AuthPhoneCubit extends Cubit<AuthPhoneState> {
  final SendOtpUseCase sendOtpUseCase;

  AuthPhoneCubit({required this.sendOtpUseCase}) : super(AuthPhoneInitial());

  Future<void> sendOtp({required String phone}) async {
    emit(AuthPhoneLoading());
    final result = await sendOtpUseCase.call(phone: phone);
    result.fold(
      (failure) => emit(AuthPhoneError(errorMessage: failure.errorMessage)),
      (entity) => emit(AuthPhoneSuccess(phone: entity.phone)),
    );
  }
}
