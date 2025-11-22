import 'package:flutter/material.dart';
import 'package:wimo/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Wimo",
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}