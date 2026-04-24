import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class EventGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventGalleryController>(() => EventGalleryController());
  }
}
