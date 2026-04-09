import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/routes.dart';
import 'package:swis_school/views/dashboard/controller.dart';
import 'package:swis_school/views/dashboard/widgets/slide_image.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final List<String> _catName = [
    "បង់ថ្លៃសិក្សា", // Payment
    "ពិនិត្យវត្តមាន", // Attendance Check
    "ស្នើរសុំច្បាប់", // Request Leave
    "កាលវិភាគសិក្សា", // Schedule
    "តារាងពិន្ទុ", // Score Table
    "កំណត់ត្រាវត្តមាន", // Student Information
    "របាយការណ៍សិស្ស", // Student Report
    "សកម្មភាពក្នុងថ្នាក់", // Class Activity
    "វគ្គសិក្សាអនឡាយ", // Online Course
  ];

  final List<Widget> catIcons = [
    Image.asset('assets/images/icon/payment.png', width: 30, height: 30),
    Image.asset('assets/images/icon/attendance.png', width: 30, height: 30),
    Image.asset(
      'assets/images/icon/attendance_leave.png',
      width: 30,
      height: 30,
    ),

    Image.asset('assets/images/icon/time_table.png', width: 30, height: 30),
    Image.asset('assets/images/icon/score.png', width: 30, height: 30),
    Image.asset(
      'assets/images/icon/list_attendance.png',
      width: 30,
      height: 30,
    ),
    Image.asset('assets/images/icon/student_report.png', width: 40, height: 40),
    Image.asset('assets/images/icon/class_activity.png', width: 30, height: 30),
    Image.asset('assets/images/icon/online_course.png', width: 40, height: 40),
  ];

  List<Color> catColors = List.filled(9, Color(0xFFEEF7FE));

  final List<String> bannerImages = [
    'https://i.pinimg.com/736x/2b/04/64/2b0464f4db9ad059f31fb6f9c05b0d01.jpg',
    'https://i.pinimg.com/736x/8c/a5/15/8ca5158965df5d14798323e7640f40f3.jpg',
    'https://i.pinimg.com/736x/2b/04/64/2b0464f4db9ad059f31fb6f9c05b0d01.jpg',
    'https://i.pinimg.com/736x/8c/a5/15/8ca5158965df5d14798323e7640f40f3.jpg',
  ];

  DashboardController controller = Get.find<DashboardController>();

  void click(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.paymentCollection);
        break;
      case 1:
        Get.toNamed(Routes.attendance);
        break;
      case 2:
        Get.toNamed(Routes.requestLeave);

        break;
      case 3:
        Get.toNamed(Routes.schedule);

        break;
      case 4:
        Get.toNamed(Routes.standings);
        break;
      case 5:
        Get.toNamed(Routes.attendance);
        break;
      case 6:
        Get.toNamed(Routes.studentDocument);
        break;
      case 7:
        Get.toNamed(Routes.eventGallery);
        break;
      case 8:
        Get.toNamed(Routes.onlineCourses);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          const SizedBox(height: 10),

          PremiumSlider(imagesList: bannerImages),
          const SizedBox(height: 10),

          // 3x3 Menu Grid
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),

              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _catName.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => click(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            color: catColors[index],
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: catIcons[index]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _catName[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Battambang',
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
