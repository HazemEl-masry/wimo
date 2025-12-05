import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

abstract class BackupLocalDataSource {
  Future<String> createBackup();
  Future<void> restoreBackup(String backupPath);
}

class BackupLocalDataSourceImpl implements BackupLocalDataSource {
  Future<File> _getDbFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, 'db.sqlite'));
  }

  @override
  Future<String> createBackup() async {
    final dbFile = await _getDbFile();
    if (!await dbFile.exists()) {
      throw Exception("Database file not found");
    }

    final backupDir = await getApplicationDocumentsDirectory();
    final fileName =
        'wimo_backup_${DateTime.now().millisecondsSinceEpoch}.sqlite';
    final backupFile = File(p.join(backupDir.path, fileName));

    await dbFile.copy(backupFile.path);
    return backupFile.path;
  }

  @override
  Future<void> restoreBackup(String backupPath) async {
    final backupFile = File(backupPath);
    if (!await backupFile.exists()) {
      throw Exception("Backup file not found at $backupPath");
    }

    final dbFile = await _getDbFile();
    // Verify it's a valid SQLite file? (Skipping for now)
    await backupFile.copy(dbFile.path);
  }
}
