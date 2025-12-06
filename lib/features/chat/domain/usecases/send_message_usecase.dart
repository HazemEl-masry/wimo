import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/core/usecase/usecase.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';
import 'package:wimo/features/chat/domain/repositories/messages_repository.dart';

/// Use case for sending a message
class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final MessagesRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(
      chatId: params.chatId,
      content: params.content,
      type: params.type,
      mediaUrl: params.mediaUrl,
    );
  }
}

class SendMessageParams {
  final String chatId;
  final String content;
  final String type;
  final String? mediaUrl;

  SendMessageParams({
    required this.chatId,
    required this.content,
    this.type = 'text',
    this.mediaUrl,
  });
}
