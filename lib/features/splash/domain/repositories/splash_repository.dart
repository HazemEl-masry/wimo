/// Repository interface for splash screen functionality
abstract class SplashRepository {
  /// Checks if the user has completed onboarding
  Future<bool> hasCompletedOnboarding();
  Future<bool> isAuthenticated();
}
