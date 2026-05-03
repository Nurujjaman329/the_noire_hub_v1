// lib/services/push_notification_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/firebase_options.dart';

import '../constants/route_constants.dart';
import 'cache_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  debugPrint('🔔 [FCM] Background message: ${message.messageId}');
  debugPrint('📦 Data: ${message.data}');
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
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      await _initLocalNotifications();

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      debugPrint('🔔 [FCM] Permission status: ${settings.authorizationStatus}');

      // 6️⃣ Listen for token refreshes (e.g., after reinstall)
      _messaging.onTokenRefresh.listen((newToken) async {
        await CacheService.saveFcmToken(newToken);
        debugPrint('🔔 [FCM] Token refreshed: $newToken');
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('🔔 [FCM] Foreground: ${message.notification?.title}');
        _showLocalNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 [FCM] Opened from background');
        _handleNotificationNavigation(message.data);
      });

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('🔔 [FCM] Opened from terminated state');
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleNotificationNavigation(initialMessage.data);
        });
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();
        debugPrint('🍎 [iOS] APNs Token: ${apnsToken ?? "null"}');
        if (apnsToken == null) {
          debugPrint(
            '⚠️ [iOS] APNs not configured! Check: '
            'Xcode Capabilities + Provisioning Profile + Firebase APNs Key',
          );
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('🔥 [FCM] Firebase error: ${e.code} - ${e.message}');
    } catch (e, stack) {
      debugPrint('🔥 [FCM] Init failed: $e\n$stack');
    }
  }

  static Future<void> _initLocalNotifications() async {
    final androidImpl = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(_messageChannel);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      settings: InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // ✅ Foreground local notification tapped
        if (response.payload != null && response.payload!.isNotEmpty) {
          _handleNotificationNavigation({'conversationId': response.payload});
        }
      },
      // onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
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
      payload: conversationId,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _messageChannel.id,
          _messageChannel.name,
          channelDescription: _messageChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: conversationId ?? 'default',
          interruptionLevel: InterruptionLevel.active,
          // categoryIdentifier: 'MESSAGE_CATEGORY',
        ),
      ),
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
      Get.toNamed(RouteConstants.conversationsScreen);
    }
  }

  static Future<String?> getToken() async {
    try {
      final cached = CacheService.fcmToken;
      if (cached.isNotEmpty) return cached;

      final token = await _messaging.getToken();
      if (token != null) {
        await CacheService.saveFcmToken(token);
      }
      return token;
    } catch (e) {
      debugPrint('🔥 [FCM] getToken error: $e');
      return null;
    }
  }

  static Future<AuthorizationStatus> getPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus;
  }
}
