import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/views/start/widgets/customize_app_bar.dart';
import 'package:ciac_school/views/views.dart';

class OnlineCoursesView extends GetView<OnlineCoursesController> {
  const OnlineCoursesView({super.key});

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
              title: 'កម្មវិធីសិក្សាផ្សេងៗ',
              subTitle: 'សូមរៀនដោយយកចិត្តទុកដាក់',
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
              child: OnlineCoursesCardWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
