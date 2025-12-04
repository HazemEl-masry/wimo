import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_state.dart';

/// Cubit for managing splash screen logic
class SplashCubit extends Cubit<SplashState> {
  final CheckOnboardingStatus checkOnboardingStatus;

  SplashCubit({required this.checkOnboardingStatus})
    : super(const SplashInitial());

  /// Check onboarding status and navigate to appropriate screen
  Future<void> checkAndNavigate() async {
    emit(const SplashChecking());

    // Small delay for splash screen effect
    await Future.delayed(const Duration(milliseconds: 3800));

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
