import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'cache_service.dart';

class SocketService {
  SocketService._();

  static IO.Socket? _socket;

  // Base URL without /api/v1/ path — socket connects to the root
  static const String _socketUrl = 'https://tonmoy3000.sobhoy.com';

  static bool get isConnected => _socket?.connected ?? false;

  static void connect() {
    if (isConnected) return;

    _socket = IO.io(
      _socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer ${CacheService.token}'})
          .setAuth({'token': CacheService.token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint('🔌 [Socket] Connected');
    });

    _socket!.onDisconnect((_) {
      debugPrint('🔌 [Socket] Disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('🔌 [Socket] Connect error: $err');
    });

    _socket!.onError((err) {
      debugPrint('🔌 [Socket] Error: $err');
    });
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
    debugPrint('🔌 [Socket] Manually disconnected');
  }

  static void joinRoom(String conversationId) {
    if (!isConnected) connect();
    _socket?.emit('joinRoom', {'conversationId': conversationId});
    debugPrint('🔌 [Socket] Joined room: $conversationId');
  }

  static void leaveRoom(String conversationId) {
    _socket?.emit('leaveRoom', {'conversationId': conversationId});
    debugPrint('🔌 [Socket] Left room: $conversationId');
  }

  static void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  static void off(String event) {
    _socket?.off(event);
  }

  static void emit(String event, dynamic data) {
    if (!isConnected) {
      debugPrint('🔌 [Socket] Not connected — cannot emit $event');
      return;
    }
    _socket?.emit(event, data);
  }
}
