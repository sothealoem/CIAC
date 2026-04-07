import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

class OnlineCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineCoursesController>(() => OnlineCoursesController());
  }
}
