import 'package:swis_school/core/services/api_service.dart';
import 'package:swis_school/core/services/end_points.dart';
import 'package:swis_school/core/services/response.dart';
import 'package:swis_school/core/utils/dialog_manager.dart';
import 'package:swis_school/core/utils/exception_manager.dart';
import 'package:swis_school/models/tracking/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceRecordController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<TrackingModel> trackings = <TrackingModel>[].obs;
  bool isDone = false;
  var selectedDate = "".obs;
  var selectedMonth = 'មករា'.obs;
  var attendanceList =
      [
        {
          "name": "សុខ សារ៉ា ថ្នាក់ ៨A",
          "date": "31-05-2026",
          "checkInMorning": "08:10 AM",
          "checkOutMorning": "11:00 AM",
          "checkInAfternoon": "02:10 PM",
          "checkOutAfternoon": "05:00 PM",
          "status": "late",
        },
        {
          "name": "សុខ សារ៉ា ថ្នាក់ ៨A",
          "date": "31-05-2026",
          "checkInMorning": "08:00 AM",
          "checkOutMorning": "11:00 AM",
          "checkInAfternoon": "02:00 PM",
          "checkOutAfternoon": "05:00 PM",
          "status": "present",
        },
      ].obs;
  void onClose() {
    searchCtl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedDate.value =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  void reset() {
    /// clear search
    searchCtl.clear();

    /// reset date to today
    final now = DateTime.now();
    selectedDate.value =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    /// reset dropdowns (example)
    selectedMonth.value = 'មករា';

    /// reload data
    fetchTracking();
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

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // ✅ FIX HERE
          ),
          child: child!,
        );
      },

      initialDate: DateTime.parse(selectedDate.value),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> filter() async {
    print("Refreshing data for: ${selectedMonth.value}");
  }
}
