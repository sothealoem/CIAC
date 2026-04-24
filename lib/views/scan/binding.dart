import 'package:ciac_school/views/scan/scan_log_controller.dart';
import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(() => ScanController());
    Get.lazyPut<CardScanController>(() => CardScanController());
  }
}
