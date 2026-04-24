import 'package:ciac_school/models/requestleave/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/models/models.dart';
import 'package:intl/intl.dart';

class RequestLeaveController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<TrackingModel> trackings = <TrackingModel>[].obs;
  var requests = <RequestLeaveModel>[].obs;
  bool isDone = false;
  var selectedClass = "ថ្នាក់ទី ៥".obs;
  var selectedShift = "".obs;
  var leaveType = "".obs;
  var startDate = "".obs;
  var endDate = "".obs;
  var isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Adding initial dummy data so the list isn't empty at start
    requests.addAll([
      RequestLeaveModel(
        name: "សិន ដារ៉ា",
        grade: '៥',
        dateStart: "20/04/2026",
        dateEnd: "22/04/2026",
        leaveType: "Sick",
        reason: "គ្រុនក្ដៅខ្លាំង",
        status: "pending",
      ),
      RequestLeaveModel(
        name: "សិន ដារ៉ា",
        grade: '៥',
        dateStart: "10/04/2026",
        dateEnd: "11/04/2026",
        leaveType: "Busy",
        reason: "រវល់ការងារគ្រួសារ",
        status: "approved",
      ),
    ]);
  }

  @override
  void onClose() {
    searchCtl.dispose();
    super.onClose();
  }

  List<String> classes = [
    "ថ្នាក់ទី ១",
    "ថ្នាក់ទី ២",
    "ថ្នាក់ទី ៣",
    "ថ្នាក់ទី ៤",
    "ថ្នាក់ទី ៥",
    "ថ្នាក់ទី ៦",
  ];
  Future<void> pickStartDate() async {
    final context = Get.overlayContext!;

    DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      startDate.value =
          "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
    }
  }

  String get _mappedLeaveType {
    if (leaveType.value == 'ឈឺ') return "Sick";
    if (leaveType.value == 'រវល់') return "Busy";
    return "Other";
  }

  Future<void> submitRequest() async {
    // 1. Validation
    if (startDate.value.isEmpty ||
        endDate.value.isEmpty ||
        leaveType.value.isEmpty) {
      Get.snackbar(
        "Error",
        "សូមបំពេញព័ត៌មានឱ្យបានគ្រប់គ្រាន់",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isloading.value = true;

    // 2. Setup IDs (Replace '1' with your actual dynamic student ID)
    const String studentId = "000001";
    final String url =
        "https://demo.school.softcreative.online/api/v1/parent/$studentId/leave-request";

    // 3. Prepare Payload
    final Map<String, dynamic> payload = {
      "date_start": _formatToIso(startDate.value),
      "date_end": _formatToIso(endDate.value),
      "leave_type": _mappedLeaveType,
      "reason": reasonController.text,
    };

    try {
      final res = await Get.find<ApiService>().post(
        url,
        payload,
        isShowLoading: false,
      );

      // 5. Handle Response
      if (res.statusCode == 200 || res.statusCode == 201) {
        // Add to local list for immediate UI feedback
        requests.insert(
          0,
          RequestLeaveModel(
            name: "សិន ដារ៉ា",
            grade: selectedClass.value,
            dateStart: startDate.value,
            dateEnd: endDate.value,
            leaveType: leaveType.value,
            reason: reasonController.text,
            status: "pending",
          ),
        );
        // Get.snackbar(
        //   "ជោគជ័យ",
        //   "សំណើរបស់លោកអ្នកត្រូវបានបញ្ជូន",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        Get.back(); // Return to the list view

        requests.refresh();
        // Reset form
        reasonController.clear();
      }
    } catch (e) {
      debugPrint("POST Error: $e");
      // Handle error (e.g., show message from server)
      ExceptionHandler.handleException(e);
    } finally {
      isloading.value = false;
    }
  }

  String _formatToIso(String dateStr) {
    if (dateStr.isEmpty) return "";
    final date = _parseDate(dateStr);
    if (date == null) return "";
    // Returns ISO format with Z suffix
    return "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date)}Z";
  }

  Future<void> pickEndDate() async {
    final context = Get.overlayContext!;

    DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      endDate.value =
          "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
    }
  }

  int get totalDays {
    if (startDate.value.isEmpty || endDate.value.isEmpty) return 0;

    final start = _parseDate(startDate.value);
    final end = _parseDate(endDate.value);

    if (start == null || end == null) return 0;

    return end.difference(start).inDays + 1; // include both days
  }

  /// helper
  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchTracking() async {
    try {
      final Map<String, dynamic> param = {'invoice': searchCtl.text};
      final res = await Get.find<ApiService>().get(
        EndPoints.tracking,
        queryParameters: param,
        isShowLoading: true,
      );
      final data = getPropertyFromJson(res.data, 'data');
      trackings.value = List.from(
        (data as List).map((e) => TrackingModel.fromJson(e)).toList(),
      );

      isDone = true;
      DialogManager.hideLoading();
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
  }
}
