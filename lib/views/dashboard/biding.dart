import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class DashbordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
