import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
