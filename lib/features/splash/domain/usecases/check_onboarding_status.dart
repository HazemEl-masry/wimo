import 'package:wimo/features/splash/domain/repositories/splash_repository.dart';

/// Use case to check if user has completed onboarding
class CheckOnboardingStatus {
  final SplashRepository repository;

  CheckOnboardingStatus(this.repository);

  /// Executes the use case
  /// Returns true if onboarding is completed, false otherwise
  Future<bool> call() async {
    return await repository.hasCompletedOnboarding();
  }
}
