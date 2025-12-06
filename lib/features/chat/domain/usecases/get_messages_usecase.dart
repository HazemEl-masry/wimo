import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';
import 'package:wimo/features/chat/domain/repositories/messages_repository.dart';

/// Use case for getting messages in a chat
class GetMessagesUseCase
    implements UseCase<List<MessageEntity>, GetMessagesParams> {
  final MessagesRepository repository;

  GetMessagesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return repository.getMessages(
      chatId: params.chatId,
      limit: params.limit,
      before: params.before,
    );
  }
}

class GetMessagesParams {
  final String chatId;
  final int? limit;
  final String? before;

  GetMessagesParams({required this.chatId, this.limit, this.before});
}
