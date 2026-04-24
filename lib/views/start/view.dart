import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/views/start/widgets/custom_appbar.dart';
import 'package:ciac_school/views/views.dart';

class StartView extends GetView<StartController> {
  const StartView({super.key});
  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
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
              profileUrl: controller.profileUrl.value,
              profileFallbackAsset: 'assets/images/teacher.jpg',
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
        floatingActionButton:
            UserRepository.shared.isDriver
                ? FloatingActionButton(
                  backgroundColor: AppColor.white,
                  shape: const CircleBorder(),
                  onPressed:
                      () async => DialogManager.showCustom(
                        ChooseOptionsDialog(
                          firstBtnOnPressed: () => controller.changeMenu(2),
                          secondBtnOnPressed:
                              () => DialogManager.showCustom(
                                EnterProductCodeDialog(),
                              ),
                        ),
                      ),
                  child: Obx(() {
                    return Icon(
                      Icons.qr_code_scanner_rounded,
                      color:
                          controller.selectedIndex.value == 2
                              ? AppColor.red
                              : AppColor.black,
                    );
                  }),
                )
                : null,

        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
              ],
            ),
            child: ConvexAppBar(
              backgroundColor: AppColor.white,
              color: AppColor.grey,
              activeColor: AppColor.primary,
              height: 60,
              style: TabStyle.reactCircle,
              initialActiveIndex: controller.selectedIndex.value,
              onTap: (index) {
                controller.changeMenuIndex(index);
              },
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
                TabItem(
                  icon: Icons.qr_code_scanner_sharp,
                  title:
                      UserRepository.shared.isDriver
                          ? LocaleKeys.scanner.tr
                          : LocaleKeys.tracking.tr,
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
        ),
      ),
    );
  }
}
