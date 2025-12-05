import 'package:fpdart/fpdart.dart';
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
      return Right(AuthEntityPhone(phone: result.phone));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntityResponse>> verifyOtp({
    required String otp,
    required String phone,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(otp: otp, phone: phone);
      // Return entity with full auth data from backend response
      return Right(
        AuthEntityResponse(
          userId: result.user.id,
          phone: result.user.phone,
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
