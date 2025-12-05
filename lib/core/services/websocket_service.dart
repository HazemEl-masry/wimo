import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wimo/core/services/token_service.dart';

/// WebSocket service for real-time chat communication
/// Manages Socket.IO connection lifecycle and provides event streams
class WebSocketService {
  final TokenService tokenService;
  final String baseUrl;

  IO.Socket? _socket;
  bool _isConnected = false;
  bool _isConnecting = false;

  // Stream controllers for different events
  final _messageReceivedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _userTypingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _userTypingStopController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _groupTypingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messageDeliveredController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messageReadController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messagesReadController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _allMessagesReadController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  // Public streams
  Stream<Map<String, dynamic>> get messageReceived =>
      _messageReceivedController.stream;
  Stream<Map<String, dynamic>> get userTyping => _userTypingController.stream;
  Stream<Map<String, dynamic>> get userTypingStop =>
      _userTypingStopController.stream;
  Stream<Map<String, dynamic>> get groupTyping => _groupTypingController.stream;
  Stream<Map<String, dynamic>> get messageDelivered =>
      _messageDeliveredController.stream;
  Stream<Map<String, dynamic>> get messageRead => _messageReadController.stream;
  Stream<Map<String, dynamic>> get messagesRead =>
      _messagesReadController.stream;
  Stream<Map<String, dynamic>> get allMessagesRead =>
      _allMessagesReadController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  // Legacy streams for backward compatibility (map to message:received)
  @Deprecated('Use messageReceived instead')
  Stream<Map<String, dynamic>> get chatUpdates =>
      _messageReceivedController.stream;
  @Deprecated('Use messageReceived instead')
  Stream<Map<String, dynamic>> get newMessages =>
      _messageReceivedController.stream;

  bool get isConnected => _isConnected;

  WebSocketService({required this.tokenService, required this.baseUrl});

  /// Initialize and connect to WebSocket server
  Future<void> connect() async {
    if (_isConnecting || _isConnected) {
      debugPrint('WebSocket: Already connected or connecting');
      return;
    }

    _isConnecting = true;

    try {
      // Get authentication token
      final token = await tokenService.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('WebSocket: No access token available');
        _isConnecting = false;
        return;
      }

      debugPrint('WebSocket: Connecting to $baseUrl');

      // Configure Socket.IO with authentication
      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Use WebSocket transport only
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(5)
            .setAuth({'token': token}) // Send token for authentication
            .build(),
      );

      // Setup event listeners
      _setupEventListeners();

      // Connect
      _socket!.connect();
    } catch (e) {
      debugPrint('WebSocket: Connection error: $e');
      _isConnecting = false;
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  /// Setup Socket.IO event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      debugPrint('WebSocket: ✅ Connected successfully');
      _isConnected = true;
      _isConnecting = false;
      _connectionStatusController.add(true);
    });

    _socket!.onDisconnect((_) {
      debugPrint('WebSocket: ❌ Disconnected');
      _isConnected = false;
      _connectionStatusController.add(false);
    });

    _socket!.onConnectError((data) {
      debugPrint('WebSocket: Connection error: $data');
      _isConnected = false;
      _isConnecting = false;
      _connectionStatusController.add(false);
    });

    _socket!.onError((data) {
      debugPrint('WebSocket: Error: $data');
    });

    _socket!.on('reconnect', (_) {
      debugPrint('WebSocket: Reconnected');
      _isConnected = true;
      _connectionStatusController.add(true);
    });

    _socket!.on('reconnect_attempt', (attempt) {
      debugPrint('WebSocket: Reconnection attempt #$attempt');
    });

    _socket!.on('reconnect_failed', (_) {
      debugPrint('WebSocket: Reconnection failed');
      _isConnected = false;
    });

    // Chat-specific events - using actual backend event names
    _socket!.on('message:received', (data) {
      debugPrint('WebSocket: Received message:received event');
      if (data is Map<String, dynamic>) {
        _messageReceivedController.add(data);
      }
    });

    _socket!.on('user_typing', (data) {
      debugPrint('WebSocket: Received user_typing event');
      if (data is Map<String, dynamic>) {
        _userTypingController.add(data);
      }
    });

    _socket!.on('user_typing_stop', (data) {
      debugPrint('WebSocket: Received user_typing_stop event');
      if (data is Map<String, dynamic>) {
        _userTypingStopController.add(data);
      }
    });

    _socket!.on('group:typing', (data) {
      debugPrint('WebSocket: Received group:typing event');
      if (data is Map<String, dynamic>) {
        _groupTypingController.add(data);
      }
    });

    _socket!.on('message:delivered', (data) {
      debugPrint('WebSocket: Received message:delivered event');
      if (data is Map<String, dynamic>) {
        _messageDeliveredController.add(data);
      }
    });

    _socket!.on('message:read', (data) {
      debugPrint('WebSocket: Received message:read event');
      if (data is Map<String, dynamic>) {
        _messageReadController.add(data);
      }
    });

    _socket!.on('messages_read', (data) {
      debugPrint('WebSocket: Received messages_read event');
      if (data is Map<String, dynamic>) {
        _messagesReadController.add(data);
      }
    });

    _socket!.on('all_messages_read', (data) {
      debugPrint('WebSocket: Received all_messages_read event');
      if (data is Map<String, dynamic>) {
        _allMessagesReadController.add(data);
      }
    });

    // Listen for token refresh
    _socket!.on('unauthorized', (_) async {
      debugPrint('WebSocket: Unauthorized, attempting to refresh token');
      await _refreshTokenAndReconnect();
    });
  }

  /// Refresh token and reconnect
  Future<void> _refreshTokenAndReconnect() async {
    disconnect();
    // Wait a bit before reconnecting
    await Future.delayed(const Duration(seconds: 2));
    await connect();
  }

  /// Emit an event to the server
  void emit(String event, dynamic data) {
    if (_socket != null && _isConnected) {
      debugPrint('WebSocket: Emitting event: $event');
      _socket!.emit(event, data);
    } else {
      debugPrint('WebSocket: Cannot emit, not connected');
    }
  }

  /// Disconnect from WebSocket server
  void disconnect() {
    debugPrint('WebSocket: Disconnecting...');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _isConnecting = false;
    _connectionStatusController.add(false);
  }

  /// Dispose and clean up resources
  void dispose() {
    debugPrint('WebSocket: Disposing service');
    disconnect();
    _messageReceivedController.close();
    _userTypingController.close();
    _userTypingStopController.close();
    _groupTypingController.close();
    _messageDeliveredController.close();
    _messageReadController.close();
    _messagesReadController.close();
    _allMessagesReadController.close();
    _connectionStatusController.close();
  }
}
