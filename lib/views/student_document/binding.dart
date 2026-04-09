import 'package:get/get.dart';
import 'package:swis_school/views/student_document/controller.dart';

class StudentDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentDocumentController>(() => StudentDocumentController());
  }
}
