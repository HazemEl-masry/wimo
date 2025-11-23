import 'package:flutter/material.dart';
import 'package:wimo/features/auth/presentation/widgets/number_verify_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: NumberVerifyWidget());
  }
}
