import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/views/start/widgets/custom_indicator.dart';
import 'package:swis_school/views/start/widgets/customize_app_bar.dart';
import 'package:swis_school/views/views.dart';

class RequestLeaveView extends GetView<RequestLeaveController> {
  const RequestLeaveView({super.key});

  void onSearch() async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    await controller.fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomizeAppBar(
              title: 'ស្នើសុំច្បាប់',
              subTitle: 'លោកអ្នកអាចបំពេញ',
            ),
            SizedBox(height: 10),
            CustomIndicator(progress: 20),
            Expanded(child: Container(child: StudentCardWidget())),
          ],
        ),
      ),
    );
  }
}
