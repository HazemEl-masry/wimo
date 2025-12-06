import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/core/widgets/overlay_message.dart';
import 'package:wimo/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:wimo/features/backup/presentation/cubit/backup_state.dart';

class BackupAndRestoreWidget extends StatelessWidget {
  const BackupAndRestoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BackupCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Backup & Restore')),
        body: BlocConsumer<BackupCubit, BackupState>(
          listener: (context, state) {
            if (state is BackupSuccess) {
              OverlayMessage.show(
                context: context,
                message: state.message,
                isError: false,
              );
            } else if (state is BackupFailure) {
              OverlayMessage.show(
                context: context,
                message: state.error,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is BackupLoading;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.backup),
                          title: const Text('Create Backup'),
                          subtitle: const Text('Save your chats to a file'),
                          onTap: isLoading
                              ? null
                              : () =>
                                    context.read<BackupCubit>().createBackup(),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.restore),
                          title: const Text('Restore Backup'),
                          subtitle: const Text('Restore chats from a file'),
                          onTap: isLoading
                              ? null
                              : () =>
                                    context.read<BackupCubit>().restoreBackup(),
                        ),
                      ),
                      SizedBox(height: 100.h),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset("assets/svg/db.svg", width: 200.w),
                          Positioned(
                            left: 120.w,
                            bottom: 50.h,
                            child: SvgPicture.asset(
                              "assets/svg/cloud.svg",
                              width: 120.w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3.w),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
