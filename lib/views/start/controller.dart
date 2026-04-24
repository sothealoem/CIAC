import 'package:ciac_school/views/scan/scan_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/models/models.dart';
import 'package:ciac_school/views/views.dart';

class StartController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxString profileUrl = ''.obs;
  final RxString userName = ''.obs;
  late Rx<Widget> selectedScreen = screens[0].obs;
  static List<Widget> screens = [
    const DashboardView(),
    NotificationView(),
    CardScanView(),
    //ScanView(),
    PaymentCollectionView(),
    ContactUsView(),
  ];

  @override
  void onInit() {
    UserRepository.shared;
    _setLocalProfileFallback();
    fetchUserProfileFromApi();

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

  void changeMenuIndex(int index) {
    if (index == 2) {
      _openScanFullScreen();
      return;
    }
    selectedIndex.value = index;
    selectedScreen.value = screens[index];
  }

  void changeMenu(
    int index, {
    bool isFromGrid = false,
    int deliveryStatus = 1,
    String dateFilter = '',
  }) async {
    if (index == 2) {
      _openScanFullScreen();
      return;
    }
    selectedIndex.value = index;
    selectedScreen.value = screens[selectedIndex.value];
  }

  Future<void> _openScanFullScreen() async {
    await Get.to(() => CardScanView());
  }

  void _setLocalProfileFallback() {
    try {
      profileUrl.value = UserRepository.shared.profile.profile;
      userName.value = UserRepository.shared.profile.name;
    } catch (_) {
      profileUrl.value = '';
      userName.value = '';
    }
  }

  Future<void> fetchUserProfileFromApi() async {
    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.profile,
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      if (data is! Map<String, dynamic>) {
        return;
      }

      final profile = ProfileModel.fromJson(data);
      UserRepository.shared.setProfile(profile);

      profileUrl.value = profile.profile;
      userName.value = profile.name;

      await SharedPreferencesManager.setValue('name', profile.name);
    } catch (_) {
      // Keep local fallback values when API call fails.
    }
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
          label: LocaleKeys.scanner.tr,
          isSelected: selectedIndex.value == 2,
          icon: Icons.timelapse_outlined,
          onTap: () => changeMenu(2),
        ),
      BottomBarWidget(
        label: LocaleKeys.payment.tr,
        isSelected: selectedIndex.value == 3,
        icon: Icons.send,
        onTap: () => changeMenu(3),
      ),
      BottomBarWidget(
        label: LocaleKeys.contactUs.tr,
        isSelected: selectedIndex.value == 4,
        icon: Icons.more,
        onTap: () => changeMenu(4),
      ),
    ];
    return items;
  }

  String getTitle() {
    switch (selectedIndex.value) {
      case 0:
        return LocaleKeys.dashboard.tr;
      case 1:
        return LocaleKeys.notification.tr;
      case 2:
        return LocaleKeys.scanner.tr;
      case 3:
        return LocaleKeys.payment.tr;
      case 4:
        return LocaleKeys.contactUs.tr;
      default:
        return "App";
    }
  }
  // String getTitle() {
  //   String title = 'StartView';

  //   switch (selectedIndex.value) {
  //     case 0:
  //       title = LocaleKeys.dashboard;
  //       break;
  //     case 1:
  //       title = LocaleKeys.payments;
  //       break;
  //     case 2:
  //       if (UserRepository.shared.isDriver) {
  //         title = LocaleKeys.scanner;
  //         break;
  //       }
  //       title = LocaleKeys.tracking;
  //       break;
  //     case 3:
  //       title = LocaleKeys.delivery;
  //       break;
  //     case 4:
  //       title = LocaleKeys.profile;
  //       break;
  //   }
  //   return title.tr;
  // }
}
