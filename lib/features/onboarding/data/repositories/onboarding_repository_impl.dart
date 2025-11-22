import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wimo/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingItem> getOnboardingItems() {
    return [
      OnboardingItem(
        title: 'Stay Connected',
        description:
            'Chat with friends and family in real-time. Send messages, photos, and videos instantly',
        iconData: Icons.chat_bubble_rounded,
        colorHex: '#6C63FF',
      ),
      OnboardingItem(
        title: 'Group Conversations',
        description:
            'Create group chats to stay in touch with multiple people. Share moments and have fun together',
        iconData: Icons.groups_rounded,
        colorHex: '#FF6584',
      ),
      OnboardingItem(
        title: 'Secure & Private',
        description:
            'Your conversations are encrypted and secure. Chat with confidence knowing your privacy is protected',
        iconData: Icons.verified_user_rounded,
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
