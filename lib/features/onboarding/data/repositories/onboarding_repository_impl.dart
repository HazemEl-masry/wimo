import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wimo/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingItem> getOnboardingItems() {
    return [
      OnboardingItem(
        title: 'Connect with your Friends',
        description:
            'Experience social networking in augmented reality and connect with friends in a whole new dimension',
        iconData: Icons.chat,
        colorHex: '#6C63FF',
      ),
      OnboardingItem(
        title: 'Share Moments',
        description:
            'Share your favorite moments with AR filters and effects that bring your stories to life',
        iconData: Icons.center_focus_strong,
        colorHex: '#FF6584',
      ),
      OnboardingItem(
        title: 'Explore Together',
        description:
            'Discover new places and experiences with your friends using interactive AR features',
        iconData: Icons.explore,
        colorHex: '#4CAF50',
      ),
    ];
  }

  @override
  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen_onboarding') ?? false;
    // return false;
  }
}
