import 'package:get/get.dart';
import 'package:ciac_school/views/language/language.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(() => LanguageController());
  }
}
