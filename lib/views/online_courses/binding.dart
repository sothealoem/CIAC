import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class OnlineCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineCoursesController>(() => OnlineCoursesController());
  }
}
