import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/core/models/message_model.dart' as models;
import 'package:wimo/core/services/websocket_service.dart';
import 'package:wimo/core/utils/logger.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';
import 'package:wimo/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:wimo/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:wimo/features/chat/presentation/cubit/messages_state.dart';

/// Messages cubit for managing chat messages
class MessagesCubit extends Cubit<MessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final WebSocketService webSocketService;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _typingSubscription;

  MessagesCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.webSocketService,
  }) : super(MessagesInitial());

  List<MessageEntity> _currentMessages = [];
  String? _chatId;

  /// Load messages for a chat and setup real-time listeners
  Future<void> loadMessages(String chatId, {int limit = 50}) async {
    try {
      _chatId = chatId;
      emit(MessagesLoading());
      AppLogger.logBlocEvent('MessagesCubit', 'loadMessages($chatId)');

      // Setup WebSocket listeners
      _setupListeners();

      final result = await getMessagesUseCase(
        GetMessagesParams(chatId: chatId, limit: limit),
      );

      result.fold(
        (failure) {
          AppLogger.error('Failed to load messages', failure.errorMessage);
          emit(MessagesError(errorMessage: failure.errorMessage));
        },
        (messages) {
          _currentMessages = messages;
          AppLogger.info('Loaded ${messages.length} messages');
          emit(MessagesLoaded(messages: messages));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading messages', e, stackTrace);
      emit(MessagesError(errorMessage: e.toString()));
    }
  }

  void _setupListeners() {
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();

    _messageSubscription = webSocketService.messageReceived.listen((data) {
      if (_chatId == null) return;

      try {
        // Parse message
        final messageModel = models.MessageModel.fromJson(data);

        // Only add if it belongs to current chat
        if (messageModel.chatId == _chatId) {
          final messageEntity = _mapModelToEntity(messageModel);
          addMessage(messageEntity);
        }
      } catch (e) {
        AppLogger.error('Failed to parse incoming message', e.toString());
      }
    });

    _typingSubscription = webSocketService.userTyping.listen((data) {
      if (_chatId == null) return;

      final chatId = data['chatId'];
      final userId = data['userId'];
      final userName = data['userName'] ?? 'Someone';

      if (chatId == _chatId) {
        showTyping(userId, userName);
      }
    });
  }

  /// Send a new message
  Future<void> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
  }) async {
    try {
      if (content.trim().isEmpty) return;

      AppLogger.logBlocEvent('MessagesCubit', 'sendMessage');

      // Optimistic update could be added here

      final result = await sendMessageUseCase(
        SendMessageParams(chatId: chatId, content: content.trim(), type: type),
      );

      result.fold(
        (failure) {
          AppLogger.error('Failed to send message', failure.errorMessage);
          emit(MessagesError(errorMessage: failure.errorMessage));
          // Restore previous state
          emit(MessagesLoaded(messages: _currentMessages));
        },
        (message) {
          _currentMessages = [message, ..._currentMessages];
          AppLogger.info('Message sent successfully');
          emit(MessagesLoaded(messages: _currentMessages));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error sending message', e, stackTrace);
      emit(MessagesError(errorMessage: e.toString()));
      emit(MessagesLoaded(messages: _currentMessages));
    }
  }

  /// Add a new message (from WebSocket)
  void addMessage(MessageEntity message) {
    // Avoid duplicates
    if (_currentMessages.any((m) => m.id == message.id)) return;

    _currentMessages = [message, ..._currentMessages];
    emit(MessagesLoaded(messages: _currentMessages));
  }

  /// Show typing indicator
  void showTyping(String userId, String userName) {
    if (state is MessagesLoaded || state is UserTyping) {
      emit(UserTyping(userId: userId, userName: userName));

      // Auto-hide after 3 seconds if no stop event received
      Future.delayed(const Duration(seconds: 3), () {
        if (!isClosed && state is UserTyping) {
          emit(MessagesLoaded(messages: _currentMessages));
        }
      });
    }
  }

  /// Emit typing event
  void sendTyping() {
    if (_chatId != null) {
      webSocketService.emit('user_typing', {'chatId': _chatId});
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    return super.close();
  }

  // Helper to map model to entity
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
