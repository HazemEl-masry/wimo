import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerifyOtpCubit({required this.verifyOtpUseCase}) : super(VerifyOtpInitial());

  Future<void> verifyOtp({required String phone, required String otp}) async {
    emit(VerifyOtpLoading());
    final result = await verifyOtpUseCase.call(phone: phone, otp: otp);
    result.fold(
      (failure) => emit(VerifyOtpError(errorMessage: failure.errorMessage)),
      (entity) => emit(VerifyOtpSuccess(phone: entity.phone, otp: entity.otp)),
    );
  }
}
