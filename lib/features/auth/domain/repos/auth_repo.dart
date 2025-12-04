import 'package:dartz/dartz.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthEntitiePhone>> sendOtp({required String phone});
  Future<Either<Failure, AuthEntitieOtp>> verifyOtp({
    required String phone,
    required String otp,
  });
}
