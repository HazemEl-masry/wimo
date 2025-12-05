import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/core/services/token_service.dart';
import 'package:wimo/features/user/data/datasource/user_remote_data_source.dart';
import 'package:wimo/features/user/domain/entities/user_entity.dart';
import 'package:wimo/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final TokenService tokenService;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Fetch current user profile from API (uses stored auth token)
      final user = await remoteDataSource.getProfile();

      // Map to entity
      final entity = UserEntity(
        id: user.id,
        phone: user.phone,
        name: user.name,
        bio: user.bio,
        avatar: user.avatar,
        isOnline: user.isOnline,
        lastSeen: user.lastSeen,
      );

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? bio,
    String? avatar,
  }) async {
    try {
      // Note: Current data source doesn't support avatar in updateProfile
      // Avatar upload would need separate uploadAvatar method
      final user = await remoteDataSource.updateProfile(name: name, bio: bio);

      final entity = UserEntity(
        id: user.id,
        phone: user.phone,
        name: user.name,
        bio: user.bio,
        avatar: user.avatar,
        isOnline: user.isOnline,
        lastSeen: user.lastSeen,
      );

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
