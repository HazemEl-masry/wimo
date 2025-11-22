import 'package:wimo/features/onboarding/domain/entities/onboarding_item.dart';

abstract class OnboardingRepository {
  List<OnboardingItem> getOnboardingItems();
  Future<void> completeOnboarding();
  Future<bool> hasSeenOnboarding();
}
