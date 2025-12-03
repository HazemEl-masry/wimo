import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wimo/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository repository;

  OnboardingCubit({required this.repository})
    : super(OnboardingState.initial());

  void loadOnboarding() {
    final items = repository.getOnboardingItems();
    emit(
      state.copyWith(
        items: items,
        currentPage: 0,
        isLastPage: items.length == 1,
      ),
    );
  }

  void onPageChanged(int pageIndex) {
    emit(
      state.copyWith(
        currentPage: pageIndex,
        isLastPage: pageIndex == state.items.length - 1,
      ),
    );
  }

  void onNextPressed() {
    if (!state.isLastPage) {
      emit(
        state.copyWith(
          currentPage: state.currentPage + 1,
          isLastPage: state.currentPage + 1 == state.items.length - 1,
        ),
      );
    } else {
      completeOnboarding();
    }
  }

  void onSkipPressed() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    await repository.completeOnboarding();
    emit(state.copyWith(isCompleted: true));
  }
}
