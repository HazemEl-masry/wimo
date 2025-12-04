import 'package:dartz/dartz.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';
import 'package:wimo/features/auth/domain/repos/auth_repo.dart';

abstract class AuthUsecase {
  Future<Either<Failure, AuthEntitiePhone>> sendOtp({required String phone});
  Future<Either<Failure, AuthEntitieOtp>> verifyOtp({
    required String phone,
    required String otp,
  });
}

class AuthUsecaseImpl implements AuthUsecase {
  final AuthRepo authRepo;

  AuthUsecaseImpl({required this.authRepo});

  @override
  Future<Either<Failure, AuthEntitiePhone>> sendOtp({required String phone}) {
    return authRepo.sendOtp(phone: phone);
  }

  @override
  Future<Either<Failure, AuthEntitieOtp>> verifyOtp({
    required String phone,
    required String otp,
  }) {
    return authRepo.verifyOtp(phone: phone, otp: otp);
  }
}
