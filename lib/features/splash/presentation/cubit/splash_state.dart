/// States for SplashCubit
abstract class SplashState {
  const SplashState();
}

/// Initial state when splash screen loads
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// State while checking onboarding status
class SplashChecking extends SplashState {
  const SplashChecking();
}

/// State to navigate to home screen
class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}

/// State to navigate to onboarding screen
class SplashNavigateToOnboarding extends SplashState {
  const SplashNavigateToOnboarding();
}
