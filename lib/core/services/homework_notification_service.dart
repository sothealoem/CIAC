import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:schoolapp/routes.dart';

const AndroidNotificationChannel _homeworkChannel = AndroidNotificationChannel(
  'homework_channel',
  'Homework Notifications',
  description: 'Alerts students when new homework is assigned.',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('homework_notification'),
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class HomeworkNotificationService {
  HomeworkNotificationService._();

  static final HomeworkNotificationService instance =
      HomeworkNotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.createNotificationChannel(_homeworkChannel);
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    _initialized = true;
  }

  Future<void> handleInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (!_isHomeworkMessage(message)) return;

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ??
          message.data['title']?.toString() ??
          'New Homework',
      message.notification?.body ??
          message.data['body']?.toString() ??
          'You have a new homework assignment.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'homework_channel',
          'Homework Notifications',
          channelDescription: 'Alerts students when new homework is assigned.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('homework_notification'),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'homework_notification.wav',
        ),
      ),
      payload: 'homework',
    );
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload == 'homework') {
      unawaited(Get.toNamed(Routes.homework));
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    if (_isHomeworkMessage(message)) {
      unawaited(Get.toNamed(Routes.homework));
    }
  }

  bool _isHomeworkMessage(RemoteMessage message) {
    final type = (message.data['type'] ?? '').toString().trim().toLowerCase();
    final category =
        (message.data['category'] ?? '').toString().trim().toLowerCase();
    final title =
        (message.notification?.title ?? message.data['title'] ?? '')
            .toString()
            .toLowerCase();

    return type == 'homework' ||
        category == 'homework' ||
        title.contains('homework');
  }
}
