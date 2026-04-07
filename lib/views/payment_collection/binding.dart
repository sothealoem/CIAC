import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

class PaymentCollectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentCollectionController>(() => PaymentCollectionController());
  }
}
