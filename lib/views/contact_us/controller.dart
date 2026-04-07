import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/models/models.dart';

class ContactUsController extends GetxController {
  final Rxn<ContactUsModel> contactUs = Rxn<ContactUsModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await fetchContactUs();
    super.onInit();
  }

  Future<void> fetchContactUs() async {
    try {
      isLoading.value = true;

      final res = await Get.find<ApiService>().get(EndPoints.contactUs);
      final data = getPropertyFromJson(res.data, 'data');

      contactUs.value = ContactUsModel.fromJson(data);
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }
}
