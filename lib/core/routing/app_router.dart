import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/app/presentation/cubit/app_state_cubit.dart';
import 'package:wimo/features/app/presentation/cubit/connection_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/auth_phone_cubit/auth_phone_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/auth/presentation/screens/auth_screen.dart';
import 'package:wimo/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:wimo/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:wimo/features/home/presentation/cubit/chat_list_cubit.dart';
import 'package:wimo/features/home/presentation/screens/home_screen.dart';
import 'package:wimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:wimo/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:wimo/features/settings/presentation/widgets/backup_and_restore_widget.dart';
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
  static const String backupAndRestore = '/backup_and_restore';

  static final _appStateCubit = sl<AppStateCubit>();

  static GoRouter router = GoRouter(
    initialLocation: splash,
    refreshListenable: _AppStateNotifier(_appStateCubit),
    redirect: (context, state) {
      final isAuthenticated = _appStateCubit.state.isAuthenticated;
      final isOnSplash = state.matchedLocation == splash;
      final isOnAuth = state.matchedLocation == auth;
      final isOnOnboarding = state.matchedLocation == onboarding;

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isOnSplash && !isOnAuth && !isOnOnboarding) {
        return auth;
      }

      return null; // No redirect needed
    },
    routes: [
      // Wrap entire app with global providers
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<AppStateCubit>()),
              BlocProvider(create: (_) => sl<ConnectionCubit>()),
              BlocProvider(create: (_) => sl<ProfileCubit>()),
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
            builder: (context, state) => BlocProvider(
              create: (context) => sl<ChatListCubit>(),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: contacts,
            name: 'contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: '/chat/:chatId',
            name: 'chat',
            builder: (context, state) {
              final chatId = state.pathParameters['chatId']!;
              final extra = state.extra as Map<String, dynamic>?;

              return ChatRoomScreen(
                chatId: chatId,
                chatName: extra?['recipientName'] ?? 'Chat',
                chatAvatar: extra?['recipientAvatar'],
                isOnline: extra?['isOnline'] ?? false,
              );
            },
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: backupAndRestore,
            name: 'backup_and_restore',
            builder: (context, state) => const BackupAndRestoreWidget(),
          ),
        ],
      ),
    ],
  );
}

/// Converts AppStateCubit stream to ChangeNotifier for GoRouter
class _AppStateNotifier extends ChangeNotifier {
  final AppStateCubit _appStateCubit;

  _AppStateNotifier(this._appStateCubit) {
    _appStateCubit.stream.listen((_) {
      notifyListeners();
    });
  }
}
