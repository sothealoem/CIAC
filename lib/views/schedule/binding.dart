import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
