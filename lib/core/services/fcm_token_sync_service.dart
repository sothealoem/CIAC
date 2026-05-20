import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:schoolapp/core/constants/storage_key.dart';
import 'package:schoolapp/core/libraries/shared_preferences.dart';
import 'package:schoolapp/core/services/api_service.dart';
import 'package:schoolapp/core/services/end_points.dart';
import 'package:schoolapp/flavor/app_config.dart';

class FcmTokenSyncService {
  FcmTokenSyncService._();

  static final FcmTokenSyncService instance = FcmTokenSyncService._();

  static const String _lastSyncedTokenKey = 'last_synced_fcm_token';

  final Logger _logger = Logger('FcmTokenSyncService');
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) {
        unawaited(syncToken(token, force: true));
      },
      onError: (Object error, StackTrace stackTrace) {
        _logger.warning('Unable to listen for FCM token refresh', error, stackTrace);
      },
    );

    _initialized = true;
    unawaited(syncCurrentTokenIfAuthenticated());
  }

  Future<void> syncCurrentTokenIfAuthenticated({bool force = false}) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.trim().isEmpty) return;
    debugPrint('FCM token: ${token.trim()}');
    await syncToken(token, force: force);
  }

  Future<void> syncToken(String token, {bool force = false}) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) return;
    debugPrint('FCM token: $normalizedToken');

    final authToken = await _ensureAccessToken();
    if (authToken.isEmpty) return;

    final lastSyncedToken =
        (await SharedPreferencesManager.get(_lastSyncedTokenKey) ?? '')
            .toString()
            .trim();
    if (!force && lastSyncedToken == normalizedToken) return;

    try {
      final api = Get.find<ApiService>();
      await api.post(EndPoints.registerFcmToken, {
        'fcm_token': normalizedToken,
        'platform': _platformName,
      });
      await SharedPreferencesManager.setValue(
        _lastSyncedTokenKey,
        normalizedToken,
      );
    } catch (error, stackTrace) {
      _logger.warning('Unable to sync FCM token to backend', error, stackTrace);
    }
  }

  Future<String> _ensureAccessToken() async {
    if (AppConfig.shared.authorizationToken.isNotEmpty) {
      return AppConfig.shared.authorizationToken;
    }

    final rawToken =
        (await SharedPreferencesManager.get(Credential.token.name) ?? '')
            .toString()
            .trim();
    if (rawToken.isEmpty) return '';

    AppConfig.shared.token = rawToken;
    return AppConfig.shared.authorizationToken;
  }

  String get _platformName {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }
}
