// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:swis_school/core/core.dart';
// import 'package:swis_school/routes.dart';
// import 'package:swis_school/views/dashboard/controller.dart';
// import 'package:swis_school/views/dashboard/widgets/slide_image.dart';

// class DashboardWidget extends StatefulWidget {
//   const DashboardWidget({super.key});

//   @override
//   State<DashboardWidget> createState() => _DashboardWidgetState();
// }

// class _DashboardWidgetState extends State<DashboardWidget> {
//   final List _catName = [
//     r"បង់ថ្លៃសិក្សា",
//     r"វគ្គសិក្សាអនឡាយ",
//     r"កាលវិភាគសិក្សា",
//     r"ស្នើរសុំច្បាប់",
//     r"តារាងពិន្ទុ",
//     r"ពិនិត្យវត្ដមាន",
//     r"ព័ត៌មានសិស្ស",
//     r"សកម្មភាពក្នុងថ្នាក់",
//     r"រាយការណ៍សិស្ស",
//   ];
//   final List _catName2 = [r"ការជូនដំណឹង", r"ទំនាក់ទំនងសាលា", r"ទំនាក់ទំនងគ្រូ"];

//   List<Color> catColors = [
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//     Color(0xFFEEF7FE),
//   ];

//   List imageList = [
//     {"id": 2, "image_path": "assets/images/banner2.png"},
//     {"id": 3, "image_path": "assets/images/banner1.png"},
//     {"id": 1, "image_path": "assets/images/banner_store.png"},
//     {"id": 2, "image_path": "assets/images/banner2.png"},
//     {"id": 3, "image_path": "assets/images/banner1.png"},
//   ];

//   //  final CarouselController carouselController = CarouselController();
//   int currentIndex = 0;

//   final List<Widget> catIcons = [
//     Image.asset('assets/images/icon/payment.png', width: 30, height: 30),
//     Image.asset('assets/images/icon/attendance.png', width: 30, height: 30),
//     Image.asset(
//       'assets/images/icon/attendance_leave.png',
//       width: 30,
//       height: 30,
//     ),
//     Image.asset('assets/images/icon/time_table.png', width: 30, height: 30),
//     Image.asset('assets/images/icon/score.png', width: 30, height: 30),
//     Image.asset(
//       'assets/images/icon/list_attendance.png',
//       width: 30,
//       height: 30,
//     ),
//     Image.asset('assets/images/icon/student_report.png', width: 40, height: 40),
//     Image.asset('assets/images/icon/class_activity.png', width: 30, height: 30),
//     Image.asset('assets/images/icon/online_course.png', width: 40, height: 40),
//   ];

//   List<Color> getColorsRep = [
//     Color(0xFF61BDFD),
//     Color(0xFFFC7F7F),
//     Color(0xFFCBB4FB),
//     // Color(0xFF78E667),
//   ];

//   List<Icon> getIconsRep = [
//     Icon(Icons.paid, color: Colors.white, size: 30),
//     Icon(Icons.download_done, color: Colors.white, size: 30),
//     Icon(Icons.summarize, color: Colors.white, size: 30),
//     // Icon(Icons.approval,color: Colors.white,size: 30),
//   ];

//   void click(int index) {
//     switch (index) {
//       case 0:
//         {
//           Get.back();
//           Get.toNamed(Routes.paymentCollection);
//         }
//         break;
//       case 1:
//         {
//           Get.back();
//           Get.toNamed(Routes.onlineCourses);
//         }
//         break;
//       case 2:
//         {
//           Get.back();
//           Get.toNamed(Routes.schedule);
//         }
//         break;
//       case 3:
//         {
//           Get.back();
//           Get.toNamed(Routes.requestLeave);
//         }
//         break;
//       case 4:
//         {
//           Get.back();
//           Get.toNamed(Routes.standings);
//         }
//         break;
//       case 5:
//         {
//           Get.back();
//           Get.toNamed(Routes.attendance);
//         }
//         break;
//       case 6:
//         {
//           Get.back();
//           Get.toNamed(Routes.studentInforation);
//         }
//         break;
//       case 7:
//         {
//           Get.back();
//           Get.toNamed(Routes.eventGallery);
//         }
//         break;
//     }
//   }

//   final List<String> _list = [
//     'https://i.pinimg.com/736x/2b/04/64/2b0464f4db9ad059f31fb6f9c05b0d01.jpg',
//     'https://i.pinimg.com/736x/8c/a5/15/8ca5158965df5d14798323e7640f40f3.jpg',
//     'https://i.pinimg.com/736x/2b/04/64/2b0464f4db9ad059f31fb6f9c05b0d01.jpg',
//     'https://i.pinimg.com/736x/8c/a5/15/8ca5158965df5d14798323e7640f40f3.jpg',
//   ];

//   DashboardController controller = Get.find<DashboardController>();
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     List pages = [buildPageview2(size), buildPageview3(size)];
//     return Container(
//       // decoration: BoxDecoration(
//       //   image: DecorationImage(
//       //     image: AssetImage("assets/images/background_menu.png"),
//       //     fit: BoxFit.fill,
//       //   ),
//       // ),
//       child: Padding(
//         padding: EdgeInsets.only(top: 10, left: 10, right: 10),
//         child: Column(
//           children: [
//             SizedBox(
//               width: size.width,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('សួសjt!', style: AppTextStyle.mediumPrimaryBold),
//                   Text(
//                     'ស្វាគមន៍មកកាន់កម្មវិធីគ្រប់គ្រងរបស់សាលា',
//                     style: AppTextStyle.smallPrimaryBold,
//                   ),
//                 ],
//               ),
//             ),
//             10.height,
//             PremiumSlider(imagesList: _list),
//             10.height,

//             //
//             SizedBox(
//               width: size.width,
//               height: size.width * 0.75,
//               child: PageView.builder(
//                 controller: controller.pageController,
//                 itemCount: 2,
//                 itemBuilder: (context, index) => pages[index],
//               ),
//             ),
//             GetBuilder<DashboardController>(
//               builder: (context) {
//                 return Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "",
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // TextButton(
//                       //   onPressed: controller.togglePage,
//                       //   style: ButtonStyle(),
//                       //   child: Row(
//                       //     mainAxisSize: MainAxisSize.min,
//                       //     children: [
//                       //       Text(
//                       //         controller.isFirst ? "មើលបន្ថែម" : 'ត្រឡប់',
//                       //         style: TextStyle(
//                       //           fontSize: 14,
//                       //           fontWeight: FontWeight.bold,
//                       //           color: Color(0xFF650386),
//                       //         ),
//                       //       ),
//                       //       SizedBox(
//                       //         width: 8,
//                       //       ), // Optional spacing between text and icon
//                       //       Icon(
//                       //         controller.isFirst
//                       //             ? Icons.arrow_forward_ios_rounded
//                       //             : Icons.arrow_back_ios,
//                       //         color: Color(0xFF650386),
//                       //         size: 14,
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //menu grid
//   SizedBox buildPageview2(Size size) {
//     return SizedBox(
//       // width: size.width,
//       //   height: size.width,
//       child: GridView.builder(
//         itemCount: _catName.length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           childAspectRatio: 1.25,
//         ),
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               click(index);
//             },
//             child: Ink(
//               child: Column(
//                 children: [
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       // image: DecorationImage(
//                       //   image: AssetImage('assets/images/background_menu.png'),
//                       // ),
//                       color: catColors[index],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(child: catIcons[index]),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     _catName[index],
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                       color: AppColor.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   SizedBox buildPageview3(Size size) {
//     return SizedBox(
//       //  width: size.width,
//       // height: size.width,
//       child: GridView.builder(
//         itemCount: _catName2.length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           childAspectRatio: 1.2,
//         ),
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {},
//             child: Ink(
//               child: Column(
//                 children: [
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       color: catColors[index],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(child: catIcons[index]),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     _catName2[index],
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

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
    "វគ្គសិក្សាអនឡាយ", // Online Course
    "កាលវិភាគសិក្សា", // Schedule
    "ស្នើរសុំច្បាប់", // Request Leave
    "តារាងពិន្ទុ", // Score Table
    "ពិនិត្យវត្តមាន", // Attendance Check
    "ព័ត៌មានសិស្ស", // Student Information
    "សកម្មភាពក្នុងថ្នាក់", // Class Activity
    "រាយការណ៍សិស្ស", // Student Report
  ];

  final List<Widget> catIcons = [
    Image.asset('assets/images/icon/payment.png', width: 30, height: 30),
    Image.asset('assets/images/icon/online_course.png', width: 40, height: 40),
    Image.asset('assets/images/icon/time_table.png', width: 30, height: 30),
    Image.asset(
      'assets/images/icon/attendance_leave.png',
      width: 30,
      height: 30,
    ),
    Image.asset('assets/images/icon/score.png', width: 30, height: 30),
    Image.asset(
      'assets/images/icon/list_attendance.png',
      width: 30,
      height: 30,
    ),
    Image.asset('assets/images/icon/student_report.png', width: 40, height: 40),
    Image.asset('assets/images/icon/class_activity.png', width: 30, height: 30),
    Image.asset('assets/images/icon/attendance.png', width: 30, height: 30),
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
        Get.toNamed(Routes.onlineCourses);
        break;
      case 2:
        Get.toNamed(Routes.schedule);
        break;
      case 3:
        Get.toNamed(Routes.requestLeave);
        break;
      case 4:
        Get.toNamed(Routes.standings);
        break;
      case 5:
        Get.toNamed(Routes.attendance);
        break;
      case 6:
        Get.toNamed(Routes.studentInforation);
        break;
      case 7:
        Get.toNamed(Routes.eventGallery);
        break;
      case 8:
        // Add route for Student Report if you have one
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
          // Header with School Logo and Welcome
          Row(children: [
             
            ],
          ),

          const SizedBox(height: 10),

          // Back to School Banner
          // Container(
          //   height: 180,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(16),
          //     image: const DecorationImage(
          //       image: AssetImage(
          //         'assets/images/back_to_school_banner.png',
          //       ), // Use your banner asset
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          //   child: Stack(
          //     children: [

          //       Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(16),
          //           gradient: LinearGradient(
          //             colors: [
          //               Colors.transparent,
          //               Colors.black.withOpacity(0.3),
          //             ],
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //           ),
          //         ),
          //       ),
          //       const Positioned(
          //         bottom: 20,
          //         left: 20,
          //         right: 20,
          //         child: Text(
          //           'Back to School',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 24,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                          style: const TextStyle(fontSize: 11.5, height: 1.2),
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
