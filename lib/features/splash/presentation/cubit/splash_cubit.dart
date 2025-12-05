import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/splash/domain/usecases/check_auth_status.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_state.dart';

/// Cubit for managing splash screen logic
class SplashCubit extends Cubit<SplashState> {
  final CheckOnboardingStatus checkOnboardingStatus;
  final CheckAuthStatus checkAuthStatus;

  SplashCubit({
    required this.checkOnboardingStatus,
    required this.checkAuthStatus,
  }) : super(const SplashInitial());

  /// Check onboarding and auth status and navigate to appropriate screen
  Future<void> checkAndNavigate() async {
    emit(const SplashChecking());

    // Small delay for splash screen effect
    await Future.delayed(const Duration(milliseconds: 3800));

    // Check onboarding status
    final hasCompletedOnboarding = await checkOnboardingStatus();

    if (hasCompletedOnboarding) {
      // Check authentication status
      final isAuthenticated = await checkAuthStatus();
      if (isAuthenticated) {
        emit(const SplashNavigateToHome());
      } else {
        emit(const SplashNavigateToAuth());
      }
    } else {
      emit(const SplashNavigateToOnboarding());
    }
  }
}
