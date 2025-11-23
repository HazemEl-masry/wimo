/// Events for SplashBloc
abstract class SplashEvent {
  const SplashEvent();
}

/// Event triggered when splash screen starts
class SplashStarted extends SplashEvent {
  const SplashStarted();
}
