import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

class StudentInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentInformationController>(() => StudentInformationController());
  }
}
