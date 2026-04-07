import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

class EventGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventGalleryController>(() => EventGalleryController());
  }
}
