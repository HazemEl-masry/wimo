import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:wimo/features/chat/domain/entities/chat_entity.dart';
import 'package:wimo/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      final chats = await remoteDataSource.getChats();
      // Map ChatModel to ChatEntity
      final entities = chats.map((chat) {
        return ChatEntity(
          id: chat.id,
          type: chat.type,
          participants: chat.participants,
          lastMessageId: chat.lastMessageId,
          lastMessageTime: chat.lastMessageTime,
          unreadCount: chat.unreadCount,
          createdAt: chat.createdAt,
          updatedAt: chat.updatedAt,
          otherParticipant: chat.otherParticipant != null
              ? ChatParticipantEntity(
                  id: chat.otherParticipant!.id,
                  name: chat.otherParticipant!.name,
                  avatar: chat.otherParticipant!.avatar,
                  isOnline: chat.otherParticipant!.isOnline,
                )
              : null,
          groupName: chat.groupName,
          groupAvatar: chat.groupAvatar,
        );
      }).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChatById({
    required String chatId,
  }) async {
    try {
      final chat = await remoteDataSource.getChatById(chatId: chatId);
      final entity = ChatEntity(
        id: chat.id,
        type: chat.type,
        participants: chat.participants,
        lastMessageId: chat.lastMessageId,
        lastMessageTime: chat.lastMessageTime,
        unreadCount: chat.unreadCount,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        otherParticipant: chat.otherParticipant != null
            ? ChatParticipantEntity(
                id: chat.otherParticipant!.id,
                name: chat.otherParticipant!.name,
                avatar: chat.otherParticipant!.avatar,
                isOnline: chat.otherParticipant!.isOnline,
              )
            : null,
        groupName: chat.groupName,
        groupAvatar: chat.groupAvatar,
      );
      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
