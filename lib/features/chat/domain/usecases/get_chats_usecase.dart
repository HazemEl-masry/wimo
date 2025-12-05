import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/chat/domain/entities/chat_entity.dart';
import 'package:wimo/features/chat/domain/repositories/chat_repository.dart';

class GetChatsUseCase {
  final ChatRepository repository;

  GetChatsUseCase({required this.repository});

  Future<Either<Failure, List<ChatEntity>>> call() async {
    return await repository.getChats();
  }
}
