import 'package:dartz/dartz.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntityPhone>> sendOtp({required String phone});
  Future<Either<Failure, AuthEntityOtp>> verifyOtp({
    required String phone,
    required String otp,
  });
}
