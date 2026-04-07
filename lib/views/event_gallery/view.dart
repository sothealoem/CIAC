import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/start/widgets/customize_app_bar.dart';
import 'package:swis_school/views/views.dart';

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
            child: CustomizeAppBar(
              title: 'ពិនិត្យសកម្មភាពក្នុងថ្នាក់',
              subTitle: 'មើលទៅបងមើលទៅ',
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        crossAxisSpacing: 10, // Spacing between columns
                        mainAxisSpacing: 10, // Spacing between rows
                        childAspectRatio:
                            1.0, // Ratio of width to height for grid cells
                      ),
                      itemBuilder: (context, index) {
                        return YourGridItemWidget(
                          index: index,
                        ); // Replace with your grid item widget
                      },
                      itemCount:
                          10, // Replace with the actual number of items in your grid
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
