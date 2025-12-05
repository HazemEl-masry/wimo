import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:wimo/core/errors/failure.dart';
import 'package:wimo/features/chat/domain/entities/chat_entity.dart';
import 'package:wimo/features/chat/domain/usecases/get_chats_usecase.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatsUseCase getChatsUseCase;
  StreamSubscription<Either<Failure, List<ChatEntity>>>? _chatsSubscription;

  ChatListCubit({required this.getChatsUseCase}) : super(ChatListInitial());

  /// Start listening to chat updates stream
  void startListening() {
    emit(ChatListLoading());

    _chatsSubscription?.cancel(); // Cancel any existing subscription
    _chatsSubscription = getChatsUseCase.call().listen(
      (result) {
        result.fold(
          (failure) => emit(ChatListError(errorMessage: failure.errorMessage)),
          (chats) => emit(ChatListSuccess(chats: chats)),
        );
      },
      onError: (error) {
        emit(ChatListError(errorMessage: error.toString()));
      },
    );
  }

  /// Stop listening to chat updates
  void stopListening() {
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
  }

  /// Force refresh (trigger immediate fetch)
  void forceRefresh() {
    // Restart the subscription to trigger immediate fetch
    startListening();
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
