import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../constants/route_constants.dart';
import 'cache_service.dart';

// Top-level — required by Firebase for background isolation
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 [FCM] Background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Android notification channel for chat messages
  static const AndroidNotificationChannel _messageChannel =
      AndroidNotificationChannel(
    'messages_channel',
    'Messages',
    description: 'Notifications for new chat messages',
    importance: Importance.high,
  );

  static Future<void> init() async {
    await Firebase.initializeApp();

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup local notifications
    await _initLocalNotifications();

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

    // Foreground: show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 [FCM] Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Background tap: app was in background, user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 [FCM] Opened from background tap');
      _handleNotificationNavigation(message.data);
    });

    // Terminated tap: app was closed, user tapped notification to open
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🔔 [FCM] Opened from terminated tap');
      // Delay navigation until app is fully loaded
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationNavigation(initialMessage.data);
      });
    }
  }

  static Future<void> _initLocalNotifications() async {
    // Create the Android high-importance channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_messageChannel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Foreground notification tapped — parse payload and navigate
        if (response.payload != null) {
          _handleNotificationNavigation({'conversationId': response.payload});
        }
      },
    );
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final conversationId = message.data['conversationId'] as String?;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title ?? 'New Message',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _messageChannel.id,
          _messageChannel.name,
          channelDescription: _messageChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: conversationId,
    );
  }

  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    final conversationId = data['conversationId'] as String?;

    if (conversationId != null && conversationId.isNotEmpty) {
      Get.toNamed(
        RouteConstants.singleConversationScreen,
        arguments: {'conversationId': conversationId},
      );
    } else {
      // No specific conversation — open the conversations list
      Get.toNamed(RouteConstants.conversationsScreen);
    }
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
