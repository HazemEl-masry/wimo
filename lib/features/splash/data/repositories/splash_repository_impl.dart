import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/services/token_service.dart';
import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wimo/features/splash/domain/repositories/splash_repository.dart';

/// Implementation of SplashRepository
class SplashRepositoryImpl implements SplashRepository {
  final OnboardingRepository onboardingRepository;
  final TokenService tokenService;
  final ApiServices apiServices;

  SplashRepositoryImpl({
    required this.onboardingRepository,
    required this.tokenService,
    required this.apiServices,
  });

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await onboardingRepository.hasSeenOnboarding();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await tokenService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      apiServices.setAuthToken(token);
      return true;
    }
    return false;
  }
}
