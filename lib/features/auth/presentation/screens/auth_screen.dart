import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:wimo/features/auth/data/repos/auth_repo_impl.dart';
import 'package:wimo/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:wimo/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:wimo/features/auth/presentation/cubit/auth_phone_cubit/auth_phone_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/auth/presentation/widgets/number_verify_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create shared dependencies
    final apiServices = ApiServices(dio: Dio());
    final dataSource = AuthRemoteDataSourceImpl(apiServices: apiServices);
    final repository = AuthRepositoryImpl(remoteDataSource: dataSource);

    return Scaffold(
      body: MultiBlocProvider(
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
        child: const NumberVerifyWidget(),
      ),
    );
  }
}
