import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/core/models/chat_model.dart';
import 'package:wimo/core/services/websocket_service.dart';
import 'package:wimo/features/chat/data/datasource/chat_local_data_source.dart';
import 'package:wimo/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:wimo/features/chat/domain/entities/chat_entity.dart';
import 'package:wimo/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final WebSocketService webSocketService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.webSocketService,
  });

  @override
  Stream<Either<Failure, List<ChatEntity>>> getChats() async* {
    // 1. Emit cached data immediately if available
    try {
      final cachedChats = await localDataSource.getCachedChats();
      if (cachedChats.isNotEmpty) {
        yield Right(_mapModelsToEntities(cachedChats));
      }
    } catch (_) {
      // Ignore cache errors, will fetch from network
    }

    // 2. Fetch initial data from network
    try {
      final chats = await remoteDataSource.getChats();
      await localDataSource.cacheChats(chats);
      yield Right(_mapModelsToEntities(chats));
    } catch (e) {
      // If initial fetch fails, try to use cached data
      try {
        final localChats = await localDataSource.getCachedChats();
        if (localChats.isNotEmpty) {
          yield Right(_mapModelsToEntities(localChats));
        } else {
          yield Left(ServerFailure(errorMessage: e.toString()));
        }
      } catch (_) {
        yield Left(ServerFailure(errorMessage: e.toString()));
      }
    }

    // 3. Listen to WebSocket updates for real-time changes
    // Using messageReceived stream which listens to backend 'message:received' event
    await for (final _ in webSocketService.messageReceived) {
      try {
        // When we receive a new message, fetch fresh data
        final chats = await remoteDataSource.getChats();
        await localDataSource.cacheChats(chats);
        yield Right(_mapModelsToEntities(chats));
      } catch (e) {
        // On error, try to use cached data
        try {
          final localChats = await localDataSource.getCachedChats();
          if (localChats.isNotEmpty) {
            yield Right(_mapModelsToEntities(localChats));
          }
        } catch (_) {
          // Silently fail, keep showing last known good state
        }
      }
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChatById({
    required String chatId,
  }) async {
    try {
      final chat = await remoteDataSource.getChatById(chatId: chatId);
      // We could cache single chat here if needed, or rely on getChats cache
      return Right(_mapModelToEntity(chat));
    } catch (e) {
      // Ideally we would try to get from local DB specific chat too
      // but for now focus on list or rely on what we have.
      // Implementing basic local fetch if needed in future
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  List<ChatEntity> _mapModelsToEntities(List<ChatModel> models) {
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  ChatEntity _mapModelToEntity(ChatModel chat) {
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
  }
}
