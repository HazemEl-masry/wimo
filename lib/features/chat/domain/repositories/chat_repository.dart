import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/chat/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats();
  Future<Either<Failure, ChatEntity>> getChatById({required String chatId});
}
