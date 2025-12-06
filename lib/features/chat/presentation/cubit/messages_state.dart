import 'package:equatable/equatable.dart';
import 'package:wimo/features/chat/domain/entities/message_entity.dart';

/// Messages state
abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MessagesInitial extends MessagesState {}

/// Loading messages
class MessagesLoading extends MessagesState {}

/// Messages loaded successfully
class MessagesLoaded extends MessagesState {
  final List<MessageEntity> messages;
  final bool hasMore;

  const MessagesLoaded({required this.messages, this.hasMore = false});

  @override
  List<Object?> get props => [messages, hasMore];
}

/// Sending message
class MessageSending extends MessagesState {
  final List<MessageEntity> currentMessages;
  final String tempMessage;

  const MessageSending({
    required this.currentMessages,
    required this.tempMessage,
  });

  @override
  List<Object?> get props => [currentMessages, tempMessage];
}

/// Message sent successfully
class MessageSent extends MessagesState {
  final MessageEntity message;

  const MessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class MessagesError extends MessagesState {
  final String errorMessage;

  const MessagesError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// Typing indicator state
class UserTyping extends MessagesState {
  final String userId;
  final String userName;

  const UserTyping({required this.userId, required this.userName});

  @override
  List<Object?> get props => [userId, userName];
}
