import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'cache_service.dart';

// Must be top-level for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 [FCM] Background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await Firebase.initializeApp();

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission (iOS / Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 [FCM] Permission: ${settings.authorizationStatus}');

    // Get and cache token
    final token = await _messaging.getToken();
    if (token != null) {
      await CacheService.saveFcmToken(token);
      debugPrint('🔔 [FCM] Token: $token');
    }

    // Refresh token listener
    _messaging.onTokenRefresh.listen((newToken) async {
      await CacheService.saveFcmToken(newToken);
      debugPrint('🔔 [FCM] Token refreshed: $newToken');
    });

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 [FCM] Foreground message: ${message.notification?.title}');
    });

    // Opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 [FCM] Opened from background: ${message.notification?.title}');
    });
  }

  static Future<String?> getToken() async {
    try {
      final cached = CacheService.fcmToken;
      if (cached.isNotEmpty) return cached;

      final token = await _messaging.getToken();
      if (token != null) await CacheService.saveFcmToken(token);
      return token;
    } catch (e) {
      debugPrint('🔔 [FCM] getToken error: $e');
      return null;
    }
  }
}
