import 'package:get/get.dart';

class NotificationController extends GetxController {
  Future<void> refreshNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
