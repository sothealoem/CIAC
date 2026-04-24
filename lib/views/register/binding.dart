import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
