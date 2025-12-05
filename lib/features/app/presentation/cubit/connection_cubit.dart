import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// States for network connectivity
abstract class ConnectionState extends Equatable {
  const ConnectionState();

  @override
  List<Object?> get props => [];
}

class ConnectionOnline extends ConnectionState {
  const ConnectionOnline();
}

class ConnectionOffline extends ConnectionState {
  const ConnectionOffline();
}

/// Cubit that monitors network connectivity status
///
/// Listens to connectivity changes and emits states accordingly.
/// Used to show offline indicators in the UI and handle offline scenarios.
class ConnectionCubit extends Cubit<ConnectionState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectionCubit() : super(const ConnectionOnline()) {
    _initializeConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Initialize connectivity status on cubit creation
  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (_) {
      // If we can't check connectivity, assume online
      emit(const ConnectionOnline());
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // If any connection is available, consider online
    if (results.contains(ConnectivityResult.none)) {
      emit(const ConnectionOffline());
    } else {
      emit(const ConnectionOnline());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
