part of 'chat_list_cubit.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListSuccess extends ChatListState {
  final List<ChatEntity> chats;

  const ChatListSuccess({required this.chats});

  @override
  List<Object> get props => [chats];
}

class ChatListError extends ChatListState {
  final String errorMessage;

  const ChatListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
