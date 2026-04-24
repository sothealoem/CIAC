import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';
import 'package:ciac_school/views/attendance/controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(() => AttendanceController());
  }
}
