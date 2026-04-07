import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/views/start/widgets/customize_app_bar.dart';
import 'package:swis_school/views/views.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  void onSearch() async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    await controller.fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: CustomizeAppBar(
              title: 'កាលវិភាគសិក្សា',
              subTitle: 'សូមពិនិត្យ',
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("assets/images/sc-background.jpg"),
                //   fit: BoxFit.fill,
                // ),
              ),
              child: ScheduleCardWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
