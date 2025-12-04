import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:wimo/features/auth/data/repos/auth_repo_impl.dart';
import 'package:wimo/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:wimo/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:wimo/features/auth/presentation/cubit/auth_phone_cubit/auth_phone_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/auth/presentation/screens/auth_screen.dart';
import 'package:wimo/features/home/presentation/screens/home_screen.dart';
import 'package:wimo/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:wimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:wimo/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:wimo/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:wimo/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';

  static GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => BlocProvider(
          create: (context) => SplashCubit(
            checkOnboardingStatus: CheckOnboardingStatus(
              SplashRepositoryImpl(
                onboardingRepository: OnboardingRepositoryImpl(),
              ),
            ),
          ),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              OnboardingCubit(repository: OnboardingRepositoryImpl())
                ..loadOnboarding(),
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) {
          // Create shared dependencies
          final apiServices = ApiServices(dio: Dio());
          final dataSource = AuthRemoteDataSourceImpl(apiServices: apiServices);
          final repository = AuthRepositoryImpl(remoteDataSource: dataSource);

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthPhoneCubit(
                  sendOtpUseCase: SendOtpUseCase(repository: repository),
                ),
              ),
              BlocProvider(
                create: (context) => VerifyOtpCubit(
                  verifyOtpUseCase: VerifyOtpUseCase(repository: repository),
                ),
              ),
            ],
            child: const AuthScreen(),
          );
        },
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
