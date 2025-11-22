import 'package:flutter/widgets.dart';

class OnboardingItem {
  final String title;
  final String description;
  final IconData iconData;
  final String colorHex;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.iconData,
    required this.colorHex,
  });
}