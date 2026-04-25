import 'package:schoolapp/views/all_requested_leave/widget/all_requested_card.dart';
import 'package:schoolapp/views/all_requested_leave/widget/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/constants/ui_constants.dart';
import 'package:schoolapp/core/extensions/int.dart';
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';
import 'package:schoolapp/views/views.dart';

class AllRequestedLeaveView extends GetView<RequestLeaveController> {
  const AllRequestedLeaveView({super.key});

  // void onSearch() async {
  //   if (!controller.formKey.currentState!.validate()) {
  //     return;
  //   }
  //   await controller.fetchTracking();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomizeAppBar(title: 'ពិនិត្យវត្តមានកូនៗ', subTitle: ''),
            Expanded(child: AllRequestedCard()),
          ],
        ),
      ),
    );
  }
}
