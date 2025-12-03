import 'package:wimo/features/onboarding/domain/entities/onboarding_item.dart';

class OnboardingState {
  final List<OnboardingItem> items;
  final int currentPage;
  final bool isLastPage;
  final bool isCompleted;

  OnboardingState({
    required this.items,
    required this.currentPage,
    required this.isLastPage,
    required this.isCompleted,
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      items: [],
      currentPage: 0,
      isLastPage: false,
      isCompleted: false,
    );
  }

  OnboardingState copyWith({
    List<OnboardingItem>? items,
    int? currentPage,
    bool? isLastPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
