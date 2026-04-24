import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/flavor/flavor.dart';
import 'package:ciac_school/models/models.dart';
import 'package:ciac_school/views/views.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final TextEditingController dateCtl = TextEditingController();

  final Rxn<DashboardModel> dashboardModel = Rxn<DashboardModel>();
  final RxBool isLoading = false.obs;

  //final StartController startCtl = Get.find<StartController>();
  StartController get startCtl => Get.find<StartController>();
  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  final PageController pageController = PageController();

  var userName = "".obs;
  bool isFirst = true;
  //get name user profile when they loggin
  String get displayName {
    if (userName.value.isEmpty) return "";
    return userName.value[0].toUpperCase() + userName.value.substring(1);
  }

  void togglePage() {
    isFirst = !isFirst;
    pageController.animateToPage(
      isFirst ? 0 : 1, // Index of the second page
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
    update();
  }

  DatePicker getDatePicker() {
    final DatePicker startPicker = DatePicker(
      controller: dateCtl,
      initialDate:
          dateCtl.text.isEmpty
              ? DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              )
              : DateTime.parse(dateCtl.text),
      minDate: DateTime(DateTime.now().year - 200),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear: DateTime.now().year - 200,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  @override
  void onInit() {
    // reasonCtl.fetchReason();
    // fetchDashboard();
    super.onInit();
    loadUserName();
  }

  @override
  void onClose() {
    dateCtl.dispose();
    super.onClose();
  }

  void gridHandleTap(DeliveryStatus status) {
    // To prevent onInit execute
    if (!AppConfig.shared.isDeliveryTapOpened) {
      AppConfig.shared.isDeliveryTapOpened = true;
    }

    int deliveryStatus = 0;
    switch (status) {
      case DeliveryStatus.success:
        deliveryStatus = 3;
        break;
      case DeliveryStatus.inProgress:
        deliveryStatus = 1;
        break;
      case DeliveryStatus.problem:
        deliveryStatus = 5;
        break;
    }

    startCtl.changeMenu(
      3,
      isFromGrid: true,
      dateFilter: dateCtl.text,
      deliveryStatus: deliveryStatus,
    );
  }

  Future<void> loadUserName() async {
    final name = await SharedPreferencesManager.get('name') ?? '';
    userName.value = name;
  }

  Future<void> fetchDashboard({String? date, bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        isLoading.value = true;
      } else {
        clearDateFilter();
      }

      final String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
      date = date ?? now;

      String endPoint = '${EndPoints.dashboard}?date=$date';
      if (!UserRepository.shared.isDriver) {
        endPoint = 'customer/$endPoint';
      }

      final res = await Get.find<ApiService>().get(
        endPoint,
        isShowLoading: false,
      );

      final data = getPropertyFromJson(res.data, 'data');

      if (!UserRepository.shared.isDriver) {
        final bookingData = getPropertyFromJson(res.data, 'booking_list');
        bookings.value = List.from(
          (bookingData as List).map((e) => BookingModel.fromJson(e)).toList(),
        );

        if (data == null || data is! List) {
          throw Exception();
        }
      }

      final DashboardModel dashboard = DashboardModel.fromJson(data[0]);
      dashboardModel.value = dashboard;
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearDateFilter() {
    dateCtl.text = '';
  }
}
