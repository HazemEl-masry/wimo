import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/features/user/domain/entities/user_entity.dart';
import 'package:wimo/features/user/domain/usecases/get_current_user_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ProfileCubit({required this.getCurrentUserUseCase}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getCurrentUserUseCase.call();
    result.fold(
      (failure) => emit(ProfileError(errorMessage: failure.errorMessage)),
      (user) => emit(ProfileLoaded(user: user)),
    );
  }

  Future<void> refreshProfile() async {
    final result = await getCurrentUserUseCase.call();
    result.fold(
      (failure) => emit(ProfileError(errorMessage: failure.errorMessage)),
      (user) => emit(ProfileLoaded(user: user)),
    );
  }
}
