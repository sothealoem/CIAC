import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:schoolapp/core/libraries/shared_preferences.dart';
import 'package:schoolapp/core/repositories/user.dart';

class ClassTopicSubscriptionService {
  ClassTopicSubscriptionService._();

  static final ClassTopicSubscriptionService instance =
      ClassTopicSubscriptionService._();

  static const String _lastTopicKey = 'last_class_topic_subscription';

  Future<void> syncSelectedClassTopic() async {
    if (!UserRepository.shared.isParent) {
      await _unsubscribePreviousTopic();
      return;
    }

    final classId =
        (await SharedPreferencesManager.get('selected_child_class_id') ?? '')
            .toString()
            .trim();
    final nextTopic = classId.isEmpty ? '' : 'class_$classId';
    final previousTopic =
        (await SharedPreferencesManager.get(_lastTopicKey) ?? '')
            .toString()
            .trim();

    if (previousTopic.isNotEmpty && previousTopic != nextTopic) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic(previousTopic);
      } catch (e) {
        debugPrint('Failed to unsubscribe from topic $previousTopic: $e');
      }
    }

    if (nextTopic.isEmpty) {
      await SharedPreferencesManager.setValue(_lastTopicKey, '');
      return;
    }

    try {
      await FirebaseMessaging.instance.subscribeToTopic(nextTopic);
      await SharedPreferencesManager.setValue(_lastTopicKey, nextTopic);
      debugPrint('Subscribed to class topic: $nextTopic');
    } catch (e) {
      debugPrint('Failed to subscribe to topic $nextTopic: $e');
    }
  }

  Future<void> clearSubscription() async {
    await _unsubscribePreviousTopic();
  }

  Future<void> _unsubscribePreviousTopic() async {
    final previousTopic =
        (await SharedPreferencesManager.get(_lastTopicKey) ?? '')
            .toString()
            .trim();
    if (previousTopic.isEmpty) {
      return;
    }

    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(previousTopic);
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic $previousTopic: $e');
    }
    await SharedPreferencesManager.setValue(_lastTopicKey, '');
  }
}
