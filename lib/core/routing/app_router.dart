import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/app/presentation/cubit/app_state_cubit.dart';
import 'package:wimo/features/app/presentation/cubit/connection_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/auth_phone_cubit/auth_phone_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/auth/presentation/screens/auth_screen.dart';
import 'package:wimo/features/contacts/data/presentation/screens/contacts_screen.dart';
import 'package:wimo/features/home/presentation/cubit/chat_list_cubit.dart';
import 'package:wimo/features/home/presentation/screens/home_screen.dart';
import 'package:wimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:wimo/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:wimo/features/splash/presentation/screens/splash_screen.dart';
import 'package:wimo/features/user/presentation/cubit/profile_cubit.dart';
import 'package:wimo/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String contacts = '/contacts';
  static const String settings = '/settings';

  static GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Wrap entire app with global providers
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<AppStateCubit>()),
              BlocProvider(create: (_) => sl<ConnectionCubit>()),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: splash,
            name: 'splash',
            builder: (context, state) => BlocProvider(
              create: (context) => sl<SplashCubit>(),
              child: const SplashScreen(),
            ),
          ),
          GoRoute(
            path: onboarding,
            name: 'onboarding',
            builder: (context, state) => BlocProvider(
              create: (context) => sl<OnboardingCubit>(),
              child: const OnboardingScreen(),
            ),
          ),
          GoRoute(
            path: auth,
            name: 'auth',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => sl<AuthPhoneCubit>()),
                  BlocProvider(create: (context) => sl<VerifyOtpCubit>()),
                ],
                child: const AuthScreen(),
              );
            },
          ),
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<ChatListCubit>()),
                BlocProvider(create: (context) => sl<ProfileCubit>()),
              ],
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: contacts,
            name: 'contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
