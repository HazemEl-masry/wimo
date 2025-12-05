import 'package:wimo/features/splash/domain/repositories/splash_repository.dart';

/// Use case to check if user is authenticated
class CheckAuthStatus {
  final SplashRepository repository;

  CheckAuthStatus(this.repository);

  /// Executes the use case
  /// Returns true if user is authenticated, false otherwise
  Future<bool> call() async {
    return await repository.isAuthenticated();
  }
}
