import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/user/domain/entities/user_entity.dart';
import 'package:wimo/features/user/domain/repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
