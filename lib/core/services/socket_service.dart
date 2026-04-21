import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'cache_service.dart';

class SocketEvents {
  static const String message = 'Message';
  static const String conversation = 'Conversation';
}

class SocketService {
  SocketService._();
  static IO.Socket? _socket;
  static const String _socketUrl = 'https://tonmoy3001.sobhoy.com';

  static void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      _socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': CacheService.token})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .build(),
    );

    _socket!.onConnect((_) => debugPrint('🟢 [Socket] Connected'));
    _socket!.onDisconnect((_) => debugPrint('🔴 [Socket] Disconnected'));
    _socket!.onConnectError((err) => debugPrint('❌ [Socket] Error: $err'));
  }

  static void on(String event, Function(dynamic) handler) => _socket?.on(event, handler);
  static void off(String event, [Function(dynamic)? handler]) =>
      handler != null ? _socket?.off(event, handler) : _socket?.off(event);
}