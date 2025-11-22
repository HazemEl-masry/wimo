import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wimo/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:wimo/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc({required this.repository})
    : super(OnboardingState.initial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) {
    final items = repository.getOnboardingItems();
    emit(
      state.copyWith(
        items: items,
        currentPage: 0,
        isLastPage: items.length == 1,
      ),
    );
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: event.pageIndex,
        isLastPage: event.pageIndex == state.items.length - 1,
      ),
    );
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (!state.isLastPage) {
      emit(
        state.copyWith(
          currentPage: state.currentPage + 1,
          isLastPage: state.currentPage + 1 == state.items.length - 1,
        ),
      );
    } else {
      add(OnboardingCompleted());
    }
  }

  void _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) {
    add(OnboardingCompleted());
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await repository.completeOnboarding();
    emit(state.copyWith(isCompleted: true));
  }
}
