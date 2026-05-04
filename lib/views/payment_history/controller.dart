import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/models.dart';

class PaymentHistoryController extends GetxController {
  final RxList<PaymentHistoryItem> payments = <PaymentHistoryItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingInvoice = false.obs;
  final RxString error = ''.obs;
  final RxString invoiceError = ''.obs;
  final RxString studentName = ''.obs;
  final RxString selectedChildAvatar = ''.obs;
  final Rxn<ParentInvoiceDetailsResponse> selectedInvoice = Rxn();
  final RxnInt loadingInvoiceId = RxnInt();
  final RxInt selectedStatusTab = 0.obs; // 0=all,1=paid,2=unpaid

  @override
  void onInit() {
    super.onInit();
    _loadSelectedChildAvatar();
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory({bool resetBeforeLoad = false}) async {
    if (resetBeforeLoad) {
      payments.clear();
      studentName.value = '';
      error.value = '';
    }
    isLoading.value = true;
    error.value = '';

    try {
      final studentId = await _resolveStudentId();
      if (studentId == null) {
        payments.clear();
        error.value = 'Student ID is required.';
        return;
      }

      final res = await Get.find<ApiService>().get(
        EndPoints.paymentHistory(studentId),
        isShowLoading: false,
      );

      if (res.data is! Map<String, dynamic>) {
        payments.clear();
        error.value = 'Invalid response data.';
        return;
      }

      final response = PaymentHistoryResponse.fromJson(res.data);
      payments.assignAll(response.data.items);

      if (response.data.items.isNotEmpty) {
        final first = response.data.items.first;
        studentName.value =
            first.studentNameKh.trim().isNotEmpty
                ? first.studentNameKh.trim()
                : first.studentName.trim();
      } else {
        studentName.value = '';
      }
    } catch (e) {
      payments.clear();
      error.value = 'Failed to load payment history.';
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      await _loadSelectedChildAvatar();
      isLoading.value = false;
    }
  }

  Future<void> _loadSelectedChildAvatar() async {
    selectedChildAvatar.value =
        (await SharedPreferencesManager.get('selected_child_avatar') ?? '')
            .toString()
            .trim();
  }

  Future<int?> _resolveStudentId() async {
    if (UserRepository.shared.isDriver) {
      final selected =
          (await SharedPreferencesManager.get('selected_child_id') ?? '')
              .toString()
              .trim();
      return int.tryParse(selected);
    }

    final keys = <String>[
      'selected_child_id',
      'student_info_id',
      'last_leave_student_id',
    ];

    for (final key in keys) {
      final raw =
          (await SharedPreferencesManager.get(key) ?? '').toString().trim();
      if (raw.isEmpty) continue;
      final parsed = int.tryParse(raw);
      if (parsed != null) return parsed;
    }
    return null;
  }

  Future<void> fetchInvoiceDetails(int id) async {
    isLoadingInvoice.value = true;
    loadingInvoiceId.value = id;
    invoiceError.value = '';
    selectedInvoice.value = null;
    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.parentInvoiceDetails(id),
        isShowLoading: false,
      );
      if (res.data is! Map<String, dynamic>) {
        invoiceError.value = 'Invalid invoice details.';
        return;
      }
      selectedInvoice.value = ParentInvoiceDetailsResponse.fromJson(res.data);
    } catch (e) {
      invoiceError.value = 'Failed to load invoice details.';
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      isLoadingInvoice.value = false;
      loadingInvoiceId.value = null;
    }
  }
}
