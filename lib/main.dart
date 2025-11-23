import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:wimo/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wimo/features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => SplashBloc(
            checkOnboardingStatus: CheckOnboardingStatus(
              SplashRepositoryImpl(
                onboardingRepository: OnboardingRepositoryImpl(),
              ),
            ),
          ),
          child: const MaterialApp(
            title: "Wimo",
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
