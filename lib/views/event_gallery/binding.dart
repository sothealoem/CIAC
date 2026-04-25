import 'package:get/get.dart';
import 'package:schoolapp/views/views.dart';

class EventGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventGalleryController>(() => EventGalleryController());
  }
}
