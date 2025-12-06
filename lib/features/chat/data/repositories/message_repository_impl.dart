import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/error/failures.dart';
import 'package:wimo/core/models/message_model.dart' as models;
import 'package:wimo/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';
import 'package:wimo/features/chat/domain/repositories/messages_repository.dart';

/// Messages repository implementation
class MessagesRepositoryImpl implements MessagesRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String chatId,
    int? limit,
    String? before,
  }) async {
    try {
      final messages = await remoteDataSource.getMessages(
        chatId: chatId,
        limit: limit,
        before: before,
      );
      return Right(_mapModelsToEntities(messages));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? mediaUrl,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        chatId: chatId,
        content: content,
        type: type,
        mediaUrl: mediaUrl,
      );
      return Right(_mapModelToEntity(message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    try {
      await remoteDataSource.markAsRead(chatId: chatId, messageIds: messageIds);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
  }) async {
    try {
      await remoteDataSource.deleteMessage(messageId: messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  // Mapping helpers
  List<MessageEntity> _mapModelsToEntities(List<models.MessageModel> models) {
    return models.map(_mapModelToEntity).toList();
  }

  MessageEntity _mapModelToEntity(models.MessageModel model) {
    return MessageEntity(
      id: model.id,
      chatId: model.chatId,
      senderId: model.senderId,
      content: model.content,
      type: model.type,
      mediaUrl: model.mediaUrl,
      isRead: model.isRead,
      readBy: model.readBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isEdited: model.isEdited,
      isDeleted: model.isDeleted,
      senderInfo: model.senderInfo != null
          ? SenderInfo(
              id: model.senderInfo!.id,
              name: model.senderInfo!.name,
              avatar: model.senderInfo!.avatar,
            )
          : null,
    );
  }
}
