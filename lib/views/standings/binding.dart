import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class StandingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StandingsController>(() => StandingsController());
  }
}
