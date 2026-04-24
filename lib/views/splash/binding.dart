import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
