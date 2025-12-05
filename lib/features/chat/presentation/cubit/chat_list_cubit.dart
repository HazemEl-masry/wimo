import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/features/chat/domain/entities/chat_entity.dart';
import 'package:wimo/features/chat/domain/usecases/get_chats_usecase.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatsUseCase getChatsUseCase;

  ChatListCubit({required this.getChatsUseCase}) : super(ChatListInitial());

  Future<void> loadChats() async {
    emit(ChatListLoading());
    final result = await getChatsUseCase.call();
    result.fold(
      (failure) => emit(ChatListError(errorMessage: failure.errorMessage)),
      (chats) => emit(ChatListSuccess(chats: chats)),
    );
  }

  Future<void> refreshChats() async {
    // Don't show loading indicator for refresh
    final result = await getChatsUseCase.call();
    result.fold(
      (failure) => emit(ChatListError(errorMessage: failure.errorMessage)),
      (chats) => emit(ChatListSuccess(chats: chats)),
    );
  }
}
