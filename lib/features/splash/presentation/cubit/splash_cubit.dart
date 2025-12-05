import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/splash/domain/usecases/check_auth_status.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_state.dart';

import 'package:wimo/core/services/token_service.dart';
import 'package:wimo/features/app/presentation/cubit/app_state_cubit.dart';

/// Cubit for managing splash screen logic
class SplashCubit extends Cubit<SplashState> {
  final CheckOnboardingStatus checkOnboardingStatus;
  final CheckAuthStatus checkAuthStatus;
  final AppStateCubit appStateCubit;
  final TokenService tokenService;

  SplashCubit({
    required this.checkOnboardingStatus,
    required this.checkAuthStatus,
    required this.appStateCubit,
    required this.tokenService,
  }) : super(const SplashInitial());

  /// Check onboarding and auth status and navigate to appropriate screen
  Future<void> checkAndNavigate() async {
    emit(const SplashChecking());

    // Reduced delay for better UX (1.5s for animation)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Run checks in parallel for faster navigation
    final results = await Future.wait([
      checkOnboardingStatus(),
      checkAuthStatus(),
    ]);

    final hasCompletedOnboarding = results[0];
    final isAuthenticated = results[1];

    // Navigate based on status
    if (!hasCompletedOnboarding) {
      emit(const SplashNavigateToOnboarding());
    } else if (isAuthenticated) {
      // Get user ID to update app state
      final userId = await tokenService.getUserId();
      appStateCubit.setAuthenticated(true, userId: userId);
      emit(const SplashNavigateToHome());
    } else {
      emit(const SplashNavigateToAuth());
    }
  }
}
