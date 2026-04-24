import 'package:get/get.dart';
import 'package:ciac_school/views/views.dart';

class PaymentCollectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentCollectionController>(
      () => PaymentCollectionController(),
    );
  }
}
