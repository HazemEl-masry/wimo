import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/services/token_service.dart';
import 'package:wimo/core/services/websocket_service.dart';
import 'package:wimo/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:wimo/features/auth/data/repos/auth_repo_impl.dart';
import 'package:wimo/features/auth/domain/repos/auth_repo.dart';
import 'package:wimo/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:wimo/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:wimo/features/auth/presentation/cubit/auth_phone_cubit/auth_phone_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:wimo/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:wimo/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:wimo/features/contacts/domain/usecases/sync_contacts_usecase.dart';
import 'package:wimo/features/contacts/domain/usecases/verify_add_contact_usecase.dart';
import 'package:wimo/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:wimo/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:wimo/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:wimo/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:wimo/features/splash/domain/repositories/splash_repository.dart';
import 'package:wimo/features/splash/domain/usecases/check_auth_status.dart';
import 'package:wimo/features/splash/domain/usecases/check_onboarding_status.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:wimo/features/user/data/datasource/user_remote_data_source.dart';
import 'package:wimo/features/contacts/data/datasources/contact_remote_data_source.dart';
import 'package:wimo/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:wimo/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:wimo/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:wimo/features/chat/domain/repositories/chat_repository.dart';
import 'package:wimo/features/chat/domain/usecases/get_chats_usecase.dart';
import 'package:wimo/core/database/app_database.dart';
import 'package:wimo/features/chat/data/datasource/chat_local_data_source.dart';
import 'package:wimo/features/backup/data/datasource/backup_local_data_source.dart';
import 'package:wimo/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:wimo/features/home/presentation/cubit/chat_list_cubit.dart';
import 'package:wimo/features/user/data/repositories/user_repository_impl.dart';
import 'package:wimo/features/user/domain/repositories/user_repository.dart';
import 'package:wimo/features/user/domain/usecases/get_current_user_usecase.dart';
import 'package:wimo/features/user/presentation/cubit/profile_cubit.dart';
import 'package:wimo/features/app/presentation/cubit/app_state_cubit.dart';
import 'package:wimo/features/app/presentation/cubit/connection_cubit.dart';
import 'package:wimo/features/chat/data/repositories/message_repository_impl.dart';
import 'package:wimo/features/chat/domain/repositories/messages_repository.dart';
import 'package:wimo/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:wimo/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:wimo/features/chat/presentation/cubit/messages_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // ==================== Splash ====================
  // Cubit
  sl.registerFactory(
    () => SplashCubit(
      checkOnboardingStatus: sl(),
      checkAuthStatus: sl(),
      appStateCubit: sl(),
      tokenService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckOnboardingStatus(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));

  // Repository
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(
      onboardingRepository: sl(),
      tokenService: sl(),
      apiServices: sl(),
    ),
  );

  // ==================== Onboarding ====================
  // Cubit
  sl.registerFactory(() => OnboardingCubit(repository: sl())..loadOnboarding());

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(),
  );

  // ==================== Authentication ====================
  // Cubits
  sl.registerFactory(() => AuthPhoneCubit(sendOtpUseCase: sl()));

  sl.registerFactory(
    () => VerifyOtpCubit(
      verifyOtpUseCase: sl(),
      tokenService: sl(),
      apiServices: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiServices: sl()),
  );

  // ==================== User Management ====================
  // Cubit
  sl.registerFactory(() => ProfileCubit(getCurrentUserUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), tokenService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiServices: sl()),
  );

  // ==================== Chat ====================
  // Cubit
  sl.registerFactory(() => ChatListCubit(getChatsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetChatsUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      webSocketService: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiServices: sl()),
  );

  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sl()),
  );

  // ==================== Messages ====================
  // Cubit
  sl.registerFactory(
    () => MessagesCubit(
      getMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
      webSocketService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMessagesUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<MessagesRepository>(
    () => MessagesRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(apiServices: sl()),
  );

  // ==================== Backup ====================
  // Cubit
  sl.registerFactory(() => BackupCubit(sl()));

  // Data sources
  sl.registerLazySingleton<BackupLocalDataSource>(
    () => BackupLocalDataSourceImpl(),
  );

  //! Core
  // Database
  sl.registerLazySingleton(() => AppDatabase());

  // Global App State
  sl.registerLazySingleton(() => AppStateCubit(tokenService: sl()));
  sl.registerLazySingleton(() => ConnectionCubit());

  // Services
  sl.registerLazySingleton(() => TokenService());
  sl.registerLazySingleton(
    () => ApiServices(
      dio: sl(),
      tokenService: sl(),
      onTokenRefreshFailed: () {
        // When token refresh fails, logout user
        sl<AppStateCubit>().logout();
      },
    ),
  );

  // WebSocket Service
  sl.registerLazySingleton(
    () => WebSocketService(
      tokenService: sl(),
      baseUrl: 'http://192.168.1.5:3000',
    ),
  );

  // Contacts Feature
  sl.registerFactory(
    () => ContactsCubit(
      getContactsUseCase: sl(),
      syncContactsUseCase: sl(),
      verifyAddContactUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetContactsUseCase(sl()));
  sl.registerLazySingleton(() => SyncContactsUseCase(sl()));
  sl.registerLazySingleton(() => VerifyAddContactUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(apiServices: sl()),
  );

  // ------------------------------------------------------------------------------------------------
  // External
  // ------------------------------------------------------------------------------------------------
  sl.registerLazySingleton(() => Dio());
}
