import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/services/token_service.dart';
import 'package:wimo/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final TokenService tokenService;
  final ApiServices apiServices;

  VerifyOtpCubit({
    required this.verifyOtpUseCase,
    required this.tokenService,
    required this.apiServices,
  }) : super(VerifyOtpInitial());

  Future<void> verifyOtp({required String phone, required String otp}) async {
    emit(VerifyOtpLoading());
    final result = await verifyOtpUseCase.call(phone: phone, otp: otp);
    result.fold(
      (failure) => emit(VerifyOtpError(errorMessage: failure.errorMessage)),
      (entity) async {
        // Save tokens to secure storage
        await tokenService.saveAuthData(
          accessToken: entity.accessToken,
          refreshToken: entity.refreshToken,
          userId: entity.userId,
        );

        // Configure API services with access token
        apiServices.setAuthToken(entity.accessToken);

        // Emit success state
        emit(
          VerifyOtpSuccess(
            userId: entity.userId,
            phone: entity.phone,
            accessToken: entity.accessToken,
          ),
        );
      },
    );
  }
}
