import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/start/widgets/custom_appbar.dart';
import 'package:schoolapp/views/views.dart';

class StartView extends GetView<StartController> {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final navFontSize =
        screenWidth < 350 ? 10.0 : (screenWidth < 390 ? 10.8 : 11.5);

    return PopScope(
      canPop: controller.selectedIndex.value == 0 ? true : false,
      onPopInvoked: (didPop) {
        controller.handleClickBack();
      },
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Obx(
            () => CustomAppBar(
              profileUrl: controller.appBarProfileUrl,
              title: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Welcome, ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text:
                          controller.userName.value.trim().isEmpty
                              ? dashboardController.displayName
                              : controller.userName.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: AppColor.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' !',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              subTitle: 'here is your dashboard.',
              imagePath: 'assets/images/sliver_banner1.png',
            ),
          ),
        ),
        drawer: const DrawerWidget(),
        body: Center(child: Obx(() => controller.selectedScreen.value)),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,

        bottomNavigationBar: Obx(() {
          final isParent = controller.isParentUser.value;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
              ],
            ),
            child: StyleProvider(
              style: _BottomNavStyle(fontSize: navFontSize),
              child: ConvexAppBar(
                key: ValueKey<String>(isParent ? 'nav-4' : 'nav-5'),
                backgroundColor: AppColor.white,
                color: AppColor.grey,
                activeColor: AppColor.primary,
                height: 66,
                style: TabStyle.reactCircle,
                initialActiveIndex: controller.selectedIndex.value,
                onTap: controller.changeMenuIndex,
                shadowColor: const Color.fromARGB(255, 179, 211, 207),
                items: [
                  TabItem(
                    icon: Icons.dashboard_outlined,
                    title: LocaleKeys.dashboard.tr,
                    fontFamily: 'Battambang',
                  ),
                  TabItem(
                    icon: Icons.notifications_outlined,
                    title: LocaleKeys.notification.tr,
                    fontFamily: 'Battambang',
                  ),
                  if (!isParent)
                    const TabItem(
                      icon: Icons.qr_code_scanner_sharp,

                      fontFamily: 'Battambang',
                    ),
                  TabItem(
                    icon: Icons.mobile_friendly_outlined,
                    title: LocaleKeys.payments.tr,
                    fontFamily: 'Battambang',
                  ),
                  TabItem(
                    icon: Icons.contact_phone,
                    title: LocaleKeys.contact.tr,
                    fontFamily: 'Battambang',
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNavStyle extends StyleHook {
  _BottomNavStyle({required this.fontSize});

  final double fontSize;

  @override
  double? get iconSize => 22;

  @override
  double get activeIconMargin => 8;

  @override
  double get activeIconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: 1.0,
    );
  }
}
