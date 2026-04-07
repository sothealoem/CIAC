import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/views.dart';

dynamic _tapFunction({required index}) {
  switch (index) {
    case 0:
      return DialogManager.showCustom(DashboardFilterDialog());
  }
}

PreferredSizeWidget appBarWidget() {
  final StartController startCtl = Get.find<StartController>();

  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            'assets/images/logo_title_05.png', // Replace with your logo asset path
            width: 230, // Adjust width as needed
            height: 190, // Adjust height as needed
          ),
        ),
      ],
    ),
    elevation: 0,
    actions: [
      Obx(() {
        if (startCtl.selectedIndex.value != 2 &&
            startCtl.selectedIndex.value != 4) {
          return Padding(
            padding: 15.padRight,
            child: Row(
              children: [
                // InkWell(
                //   child: const Icon(Icons.notifications),
                //   onTap:
                //       () => _tapFunction(index: startCtl.selectedIndex.value),
                // ),
                InkWell(
                  child: Image.asset('assets/images/user_profile.png'),
                  onTap:
                      () => _tapFunction(index: startCtl.selectedIndex.value),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    ],
  );
}
