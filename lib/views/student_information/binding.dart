import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class StudentInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentInformationController>(
      () => StudentInformationController(),
    );
  }
}
