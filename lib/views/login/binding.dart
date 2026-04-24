import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<StartController>(() => StartController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
