abstract class OnboardingEvent {}

class OnboardingStarted extends OnboardingEvent {}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;
  OnboardingPageChanged(this.pageIndex);
}

class OnboardingNextPressed extends OnboardingEvent {}

class OnboardingSkipPressed extends OnboardingEvent {}

class OnboardingCompleted extends OnboardingEvent {}
