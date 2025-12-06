import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';

/// Messages repository interface
abstract class MessagesRepository {
  /// Get messages for a specific chat
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String chatId,
    int? limit,
    String? before,
  });

  /// Send a new message
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? mediaUrl,
  });

  /// Mark messages as read
  Future<Either<Failure, void>> markAsRead({
    required String chatId,
    required List<String> messageIds,
  });

  /// Delete a message
  Future<Either<Failure, void>> deleteMessage({required String messageId});
}
