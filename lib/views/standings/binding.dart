import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

class StandingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StandingsController>(() => StandingsController());
  }
}
