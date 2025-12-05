import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wimo/core/services/token_service.dart';

/// Global application state
class AppState extends Equatable {
  final bool isAuthenticated;
  final bool isOnline;
  final String? currentUserId;

  const AppState({
    required this.isAuthenticated,
    required this.isOnline,
    this.currentUserId,
  });

  /// Create initial state
  factory AppState.initial() {
    return const AppState(isAuthenticated: false, isOnline: true);
  }

  /// Copy with updated values
  AppState copyWith({
    bool? isAuthenticated,
    bool? isOnline,
    String? currentUserId,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isOnline: isOnline ?? this.isOnline,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, isOnline, currentUserId];
}

/// Cubit managing global application state
///
/// Tracks authentication status, online/offline state, and current user.
/// Used for navigation guards and global UI state.
class AppStateCubit extends Cubit<AppState> {
  final TokenService tokenService;

  AppStateCubit({required this.tokenService}) : super(AppState.initial());

  /// Update authentication status
  void setAuthenticated(bool value, {String? userId}) {
    emit(state.copyWith(isAuthenticated: value, currentUserId: userId));
  }

  /// Update online status
  void setOnlineStatus(bool value) {
    emit(state.copyWith(isOnline: value));
  }

  /// Logout user (clear auth state and tokens)
  Future<void> logout() async {
    // Clear all tokens from secure storage
    await tokenService.clearTokens();
    // Update state to unauthenticated
    emit(state.copyWith(isAuthenticated: false, currentUserId: null));
  }

  /// Set user ID
  void setUserId(String userId) {
    emit(state.copyWith(currentUserId: userId));
  }
}
