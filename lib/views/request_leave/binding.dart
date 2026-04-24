import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class RequestLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestLeaveController>(() => RequestLeaveController());
  }
}
