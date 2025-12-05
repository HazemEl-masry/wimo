import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/backup/data/datasource/backup_local_data_source.dart';
import 'package:wimo/features/backup/presentation/cubit/backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  final BackupLocalDataSource dataSource;

  BackupCubit(this.dataSource) : super(const BackupInitial());

  Future<void> createBackup() async {
    emit(const BackupLoading());
    try {
      final path = await dataSource.createBackup();
      emit(BackupSuccess('Backup created at: $path'));
    } catch (e) {
      emit(BackupFailure(e.toString()));
    }
  }

  Future<void> restoreBackup() async {
    emit(const BackupLoading());
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        await dataSource.restoreBackup(result.files.single.path!);
        emit(
          const BackupSuccess(
            'Database restored successfully. Please restart the app.',
          ),
        );
      } else {
        emit(const BackupInitial()); // Reset if cancelled
      }
    } catch (e) {
      emit(BackupFailure(e.toString()));
    }
  }
}
