import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/views.dart';

class StartController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  late Rx<Widget> selectedScreen = screens[0].obs;
  static List<Widget> screens = [const DashboardView()];

  @override
  void onInit() {
    // Call over here becuase inside that UserRepository need to access Get.context
    // Get.context must be call after GetMaterialApp
    UserRepository.shared;

    super.onInit();
  }

  void handleClickBack() {
    if (selectedIndex.value != 0) {
      changeMenu(0);
    }
  }

  //add new
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void changeMenu(
    int index, {
    bool isFromGrid = false,
    int deliveryStatus = 1,
    String dateFilter = '',
  }) async {
    selectedIndex.value = index;
    selectedScreen.value = screens[selectedIndex.value];
  }

  List<Widget> getItems() {
    final List<Widget> items = [
      BottomBarWidget(
        label: LocaleKeys.dashboard.tr,
        isSelected: selectedIndex.value == 0,
        icon: Icons.dashboard,
        onTap: () => changeMenu(0),
      ),
      BottomBarWidget(
        label: LocaleKeys.notification.tr,
        isSelected: selectedIndex.value == 1,
        icon: Icons.payment,
        onTap: () => changeMenu(1),
      ),
      if (UserRepository.shared.isDriver)
        const Spacer()
      else
        BottomBarWidget(
          label: LocaleKeys.tracking.tr,
          isSelected: selectedIndex.value == 2,
          icon: Icons.timelapse_outlined,
          onTap: () => changeMenu(2),
        ),
      BottomBarWidget(
        label: LocaleKeys.contactUs.tr,
        isSelected: selectedIndex.value == 3,
        icon: Icons.send,
        onTap: () => changeMenu(3),
      ),
      BottomBarWidget(
        label: LocaleKeys.reason.tr,
        isSelected: selectedIndex.value == 4,
        icon: Icons.more,
        onTap: () => changeMenu(4),
      ),
    ];
    return items;
  }

  String getTitle() {
    String title = 'StartView';

    switch (selectedIndex.value) {
      case 0:
        title = LocaleKeys.dashboard;
        break;
      case 1:
        title = LocaleKeys.payments;
        break;
      case 2:
        if (UserRepository.shared.isDriver) {
          title = LocaleKeys.scanner;
          break;
        }
        title = LocaleKeys.tracking;
        break;
      case 3:
        title = LocaleKeys.delivery;
        break;
      case 4:
        title = LocaleKeys.profile;
        break;
    }
    return title.tr;
  }
}
