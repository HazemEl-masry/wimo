import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/bloc/splash_event.dart';
import 'package:wimo/features/splash/presentation/bloc/splash_state.dart';

/// BLoC for managing splash screen logic
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckOnboardingStatus checkOnboardingStatus;

  SplashBloc({required this.checkOnboardingStatus})
    : super(const SplashInitial()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashChecking());

    // Small delay for splash screen effect
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check onboarding status
    final hasCompleted = await checkOnboardingStatus();

    // Navigate to appropriate screen
    if (hasCompleted) {
      emit(const SplashNavigateToHome());
    } else {
      emit(const SplashNavigateToOnboarding());
    }
  }
}
