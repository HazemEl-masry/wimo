import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';
import 'package:wimo/features/auth/domain/repos/auth_repo.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<Either<Failure, AuthEntityResponse>> call({
    required String phone,
    required String otp,
  }) async {
    // Add OTP validation logic
    if (otp.isEmpty) {
      return Left(ServerFailure(errorMessage: 'OTP cannot be empty'));
    }

    // Basic OTP validation (typically 6 digits)
    if (otp.length != 6) {
      return Left(ServerFailure(errorMessage: 'OTP must be 6 digits'));
    }

    if (!RegExp(r'^\d+$').hasMatch(otp)) {
      return Left(ServerFailure(errorMessage: 'OTP must contain only numbers'));
    }

    return await repository.verifyOtp(phone: phone, otp: otp);
  }
}
