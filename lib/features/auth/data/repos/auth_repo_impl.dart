import 'package:dartz/dartz.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:wimo/features/auth/domain/entities/auth_entitie.dart';
import 'package:wimo/features/auth/domain/repos/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthEntityPhone>> sendOtp({
    required String phone,
  }) async {
    try {
      final result = await remoteDataSource.sendOtp(phone: phone);
      return Right(AuthEntityPhone(phone: result.phoneNumber));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntityOtp>> verifyOtp({
    required String otp,
    required String phone,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(otp: otp, phone: phone);
      return Right(
        AuthEntityOtp(phone: result.phoneNumber, otp: result.otpVerification),
      );
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
