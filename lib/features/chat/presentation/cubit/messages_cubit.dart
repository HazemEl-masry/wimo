import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/core/utils/logger.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';
import 'package:wimo/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:wimo/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:wimo/features/chat/presentation/cubit/messages_state.dart';

/// Messages cubit for managing chat messages
class MessagesCubit extends Cubit<MessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  MessagesCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(MessagesInitial());

  List<MessageEntity> _currentMessages = [];
  String? _chatId;

  /// Load messages for a chat
  Future<void> loadMessages(String chatId, {int limit = 50}) async {
    try {
      _chatId = chatId;
      emit(MessagesLoading());
      AppLogger.logBlocEvent('MessagesCubit', 'loadMessages($chatId)');

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

  /// Send a new message
  Future<void> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
  }) async {
    try {
      if (content.trim().isEmpty) return;

      AppLogger.logBlocEvent('MessagesCubit', 'sendMessage');

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
    if (message.chatId == _chatId) {
      _currentMessages = [message, ..._currentMessages];
      emit(MessagesLoaded(messages: _currentMessages));
    }
  }

  /// Show typing indicator
  void showTyping(String userId, String userName) {
    emit(UserTyping(userId: userId, userName: userName));
    // Restore messages after short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (state is UserTyping) {
        emit(MessagesLoaded(messages: _currentMessages));
      }
    });
  }
}
