import 'package:schoolapp/views/scan/scan_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/flavor.dart';
import 'package:schoolapp/models/models.dart';
import 'package:schoolapp/views/views.dart';

class StartController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxString profileUrl = ''.obs;
  final RxString userName = ''.obs;
  late Rx<Widget> selectedScreen = screens[0].obs;
  static List<Widget> screens = [
    const DashboardView(),
    const NotificationView(),
    CardScanView(),
    //ScanView(),
    const PaymentCollectionView(),
    const ContactUsView(),
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
      profileUrl.value = _normalizeProfileUrl(
        UserRepository.shared.profile.profile,
      );
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

      final rawProfileUrl = _firstNonEmpty([
        data['profile_path'],
        data['profile'],
        data['avatar'],
        data['photo'],
        data['image'],
        data['profile_url'],
      ]);

      profileUrl.value = _normalizeProfileUrl(
        rawProfileUrl.isNotEmpty ? rawProfileUrl : profile.profile,
      );
      userName.value = _firstNonEmpty([data['name'], profile.name]);

      await SharedPreferencesManager.setValue('name', userName.value);
    } catch (_) {
      // Keep local fallback values when API call fails.
    }
  }

  String get appBarProfileUrl {
    final current = profileUrl.value.trim();
    if (current.isNotEmpty) {
      return current;
    }
    try {
      return _normalizeProfileUrl(UserRepository.shared.profile.profile);
    } catch (_) {
      return '';
    }
  }

  String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = (value ?? '').toString().trim();
      if (text.isNotEmpty && text.toLowerCase() != 'n/a') {
        return text;
      }
    }
    return '';
  }

  String _normalizeProfileUrl(String? rawUrl) {
    final url = (rawUrl ?? '').trim();
    if (url.isEmpty || url.toLowerCase() == 'n/a') {
      return '';
    }
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) {
      return '';
    }

    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    return baseUri
        .resolve(url.startsWith('/') ? url.substring(1) : url)
        .toString();
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
