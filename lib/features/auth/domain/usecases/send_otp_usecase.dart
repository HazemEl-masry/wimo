import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';
import 'package:wimo/features/auth/domain/repos/auth_repo.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase({required this.repository});

  Future<Either<Failure, AuthEntityPhone>> call({required String phone}) async {
    // Add phone validation logic
    if (phone.isEmpty) {
      return Left(ServerFailure(errorMessage: 'Phone number cannot be empty'));
    }

    // Basic phone format validation (can be enhanced)
    if (phone.length < 10) {
      return Left(ServerFailure(errorMessage: 'Invalid phone number format'));
    }

    return await repository.sendOtp(phone: phone);
  }
}
