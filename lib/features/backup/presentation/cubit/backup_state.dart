abstract class BackupState {
  const BackupState();
}

class BackupInitial extends BackupState {
  const BackupInitial();
}

class BackupLoading extends BackupState {
  const BackupLoading();
}

class BackupSuccess extends BackupState {
  final String message;
  const BackupSuccess(this.message);
}

class BackupFailure extends BackupState {
  final String error;
  const BackupFailure(this.error);
}
