// lib/core/network/socket_client.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:get/get.dart';

import '/core/network/services/auth_storage_service.dart';
import 'package:flutx_core/core/debug_print.dart';
import '/features/auth/screens/login_screen.dart';
import 'api_client.dart';
import 'constants/api_constants.dart'; // For token refresh

typedef SocketEventHandler = void Function(dynamic data);

class SocketClient {
  // Singleton
  static final SocketClient _instance = SocketClient._internal();
  factory SocketClient() => _instance;
  SocketClient._internal();

  final AuthStorageService _authStorage = AuthStorageService();
  final ApiClient _apiClient = Get.find<ApiClient>();
  String get _wsUrl => ApiConstants.webSocketUrl;

  io.Socket? _socket;
  bool _manualDisconnect = false;
  bool _isConnecting = false;

  final Duration _reconnectDelay = const Duration(seconds: 3);
  final Duration _maxReconnectDelay = const Duration(seconds: 30);
  Duration _currentBackoff = const Duration(seconds: 3);

  final StreamController<Map<String, dynamic>> _messageStream =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageStream.stream;

  final Map<String, List<SocketEventHandler>> _listeners = {};
  final Completer<void> _ready = Completer<void>();

  Map<String, dynamic>? _query;
  Map<String, String>? _headers;

  bool get isConnected => _socket?.connected == true;
  Future<void> get onReady => _ready.future;

  /// Connect with auth + auto-reconnect
  Future<void> connect({
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    if (isConnected || _isConnecting) return;

    _manualDisconnect = false;
    _isConnecting = true;
    _query = query;
    _headers = headers;

    final accessToken = await _authStorage.getAccessToken();

    final authHeader = accessToken != null
        ? {'Authorization': 'Bearer $accessToken'}
        : <String, String>{};

    final allHeaders = {...?headers, ...authHeader};

    final options = io.OptionBuilder()
        .setTransports(['websocket'])
        .setPath('/socket.io')
        .setTimeout(10000)
        .setReconnectionAttempts(999)
        .setReconnectionDelay(_reconnectDelay.inMilliseconds)
        .setReconnectionDelayMax(_maxReconnectDelay.inMilliseconds)
        .setQuery({...?query})
        .setExtraHeaders(allHeaders)
        .build();

    if (kDebugMode) {
      DPrint.log("Socket.IO Connecting to: $_wsUrl");
      DPrint.log("Headers: $allHeaders | Query: $query");
    }

    _socket = io.io(_wsUrl, options);

    // Core Events
    _socket!.onConnect((_) {
      _isConnecting = false;
      _currentBackoff = _reconnectDelay;
      if (!_ready.isCompleted) _ready.complete();
      DPrint.log("Socket.IO Connected! ID: ${_socket!.id}");
    });

    _socket!.onConnectError((err) => _handleError(err));
    _socket!.onError((err) => _handleError(err));
    _socket!.onDisconnect((reason) {
      DPrint.warn("Socket.IO Disconnected: $reason");
      if (!_manualDisconnect) _scheduleReconnect();
    });

    _socket!.on('connect_timeout', (_) => _handleError('Connection timeout'));
    _socket!.on('reconnect_attempt', (attempt) {
      DPrint.log("Reconnect attempt #$attempt");
    });

    // Custom server events
    _socket!.onAny((event, data) {
      final Map<String, dynamic> message = {'event': event, 'data': data};
      _messageStream.add(message);

      if (kDebugMode) DPrint.log("Socket Event: $event → $data");

      final handlers = _listeners[event.toString()] ?? [];
      for (var handler in handlers) {
        try {
          handler(data);
        } catch (e) {
          DPrint.error("Handler error [$event]: $e");
        }
      }

      // Wildcard listeners
      _listeners['*']?.forEach((h) => h(data));
    });

    // Start connection
    _socket!.connect();
  }

  /// Send event
  void emit(String event, [dynamic data]) {
    if (!isConnected) {
      DPrint.warn("Socket not connected. Dropped emit: $event");
      return;
    }
    _socket!.emit(event, data);
    if (kDebugMode) DPrint.log("Emit → $event: $data");
  }

  /// Listen to event
  void on(String event, SocketEventHandler handler) {
    _listeners.putIfAbsent(event, () => []).add(handler);
  }

  /// Listen once
  void once(String event, SocketEventHandler handler) {
    void wrapper(dynamic data) {
      handler(data);
      off(event, wrapper);
    }

    on(event, wrapper);
  }

  /// Remove listener
  void off(String event, [SocketEventHandler? handler]) {
    if (handler == null) {
      _listeners.remove(event);
    } else {
      _listeners[event]?.remove(handler);
    }
  }

  /// Disconnect manually
  void disconnect() {
    _manualDisconnect = true;
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    if (!_ready.isCompleted) {
      _ready.completeError('Disconnected');
    }
    DPrint.warn("Socket.IO Disconnected Manually");
  }

  /// Handle errors (especially auth)
  void _handleError(dynamic error) {
    DPrint.error("Socket.IO Error: $error");

    final msg = error.toString().toLowerCase();
    if (msg.contains('401') ||
        msg.contains('unauthorized') ||
        msg.contains('invalid token')) {
      _handleUnauthorized();
    } else {
      _scheduleReconnect();
    }
  }

  /// Token expired → refresh → reconnect
  Future<void> _handleUnauthorized() async {
    DPrint.warn("Socket Unauthorized → Refreshing token...");

    final refreshed = await _refreshToken();
    if (refreshed) {
      disconnect();
      await Future.delayed(const Duration(milliseconds: 800));
      connect(query: _query, headers: _headers);
    } else {
      await _logoutAndRedirect();
    }
  }

  /// Reuse your ApiClient refresh logic
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _authStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final result = await _apiClient.post<Map<String, dynamic>>(
        endpoint: '/auth/refresh-token', // change if needed
        data: {'refreshToken': refreshToken},
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold((failure) => false, (success) {
        final data = success.data;
        _authStorage.storeAccessToken(accessToken: data['accessToken']);
        _authStorage.storeRefreshToken(refreshToken: data['refreshToken']);
        DPrint.log("Token refreshed for Socket.IO");
        return true;
      });
    } catch (e) {
      DPrint.error("Token refresh failed: $e");
      return false;
    }
  }

  void _scheduleReconnect() {
    if (_manualDisconnect || _socket?.connected == true) return;

    _currentBackoff = Duration(
      milliseconds: ((_currentBackoff.inMilliseconds * 1.5).toInt()).clamp(
        _reconnectDelay.inMilliseconds,
        _maxReconnectDelay.inMilliseconds,
      ),
    );

    DPrint.log("Socket.IO reconnecting in ${_currentBackoff.inSeconds}s...");
    Future.delayed(_currentBackoff, () {
      if (!_manualDisconnect) {
        connect(query: _query, headers: _headers);
      }
    });
  }

  Future<void> _logoutAndRedirect() async {
    await _authStorage.clearAuthData();
    clearListeners();
    Get.offAll(() => LoginScreen());
  }

  /// Clear all listeners (use on logout)
  void clearListeners() {
    _listeners.clear();
    _socket?.clearListeners();
  }

  /// Full cleanup
  void dispose() {
    disconnect();
    _messageStream.close();
    clearListeners();
  }
}
