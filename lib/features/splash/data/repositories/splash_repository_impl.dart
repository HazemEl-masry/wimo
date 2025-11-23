import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wimo/features/splash/domain/repositories/splash_repository.dart';

/// Implementation of SplashRepository
/// Delegates to OnboardingRepository to maintain single source of truth
class SplashRepositoryImpl implements SplashRepository {
  final OnboardingRepository onboardingRepository;

  SplashRepositoryImpl({required this.onboardingRepository});

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await onboardingRepository.hasSeenOnboarding();
  }
}
