import 'package:swis_school/models/requestleave/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/models/models.dart';

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

  Future<void> submitRequest() async {
    isloading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    requests.add(
      RequestLeaveModel(
        name: "សិន ដារ៉ា",
        grade: selectedClass.value,
        dateStart: startDate.value,
        dateEnd: endDate.value,
        reason: reasonController.text,
        status: "pending",
      ),
    );
    isloading.value = false;
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
