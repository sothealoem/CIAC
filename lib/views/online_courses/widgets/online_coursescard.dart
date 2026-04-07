import 'package:flutter/material.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/online_courses/widgets/videosection.dart';

class OnlineCoursesCardWidget extends StatelessWidget {
  const OnlineCoursesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                image: AssetImage("assets/images/banner1.png"),
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
          5.height,
          Text("មេរៀនទី១", style: AppTextStyle.midSecondaryBold),
          2.height,
          Text(
            "បង្រៀនដោយ លោកគ្រូ ទុយ រ៉ាវី",
            style: AppTextStyle.normalPrimarySemiBold,
          ),
          2.height,
          Text("55 video", style: AppTextStyle.normalPrimarySemiBold),
          2.height,
          VideoSectionWidget(),
        ],
      ),
    );
  }
}
