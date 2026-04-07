import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

class DashbordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
