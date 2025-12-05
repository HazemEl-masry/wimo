import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:wimo/features/backup/presentation/cubit/backup_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BackupCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: BlocConsumer<BackupCubit, BackupState>(
          listener: (context, state) {
            if (state is BackupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is BackupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is BackupLoading;
            return Stack(
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.backup),
                      title: const Text('Create Backup'),
                      subtitle: const Text('Save your chats to a file'),
                      onTap: isLoading
                          ? null
                          : () => context.read<BackupCubit>().createBackup(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.restore),
                      title: const Text('Restore Backup'),
                      subtitle: const Text('Restore chats from a file'),
                      onTap: isLoading
                          ? null
                          : () => context.read<BackupCubit>().restoreBackup(),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
