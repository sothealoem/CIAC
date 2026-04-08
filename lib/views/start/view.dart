import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/start/widgets/custom_appbar.dart';
import 'package:swis_school/views/views.dart';

class StartView extends GetView<StartController> {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.selectedIndex.value == 0 ? true : false,
      onPopInvoked: (didPop) {
        controller.handleClickBack();
      },
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(
          // title: controller.getTitle(),
          title: '',
          imagePath: 'assets/images/sliver_banner1.png', // your header image
        ),
        //appBar: appBarWidget(),
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
                controller.selectedIndex.value = index;
              },
              shadowColor: const Color.fromARGB(255, 179, 211, 207),
              items: [
                TabItem(icon: Icons.dashboard, title: LocaleKeys.dashboard.tr),
                TabItem(icon: Icons.notifications, title: LocaleKeys.amount.tr),
                TabItem(
                  icon: Icons.qr_code_scanner_sharp,
                  title:
                      UserRepository.shared.isDriver
                          ? LocaleKeys.scanner.tr
                          : LocaleKeys.tracking.tr,
                ),
                TabItem(icon: Icons.payment, title: LocaleKeys.payments.tr),

                TabItem(icon: Icons.person, title: LocaleKeys.profile.tr),
              ],
            ),
          ),
        ),

        // bottomNavigationBar: BottomAppBar(
        //   elevation: 0,
        //   surfaceTintColor: AppColor.red,
        //   height: 70,
        //   color: AppColor.white,
        //   padding: 4.padHorizontal,
        //   shape: const CircularNotchedRectangle(),
        //   child: Expanded(
        //     child: Obx(
        //       () => Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         // children: [...controller.getItems().map((e) => e)],
        //         children:
        //             controller.getItems().map((e) {
        //               return Expanded(child: e);
        //             }).toList(),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
