import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/views/start/widgets/custom_indicator.dart';
import 'package:ciac_school/views/start/widgets/customize_app_bar.dart';
import 'package:ciac_school/views/views.dart';

class EventGalleryView extends GetView<EventGalleryController> {
  const EventGalleryView({super.key});

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
            bottom: false,
            child: CustomizeAppBar(
              title: 'សកម្មភាពក្នុងថ្នាក់',
              subTitle: 'សូមពិនិត្យសកម្មភាពកូនៗ​ របស់លោកអ្នកខាងក្រោមនេះ',
            ),
          ),
          UIConstants.spacing.height,
          CustomIndicator(progress: 1 / 4),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/images/event.png"),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: 5.padAll,
                    margin: 5.padAll,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        return YourGridItemWidget(index: index);
                      },
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
