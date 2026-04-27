import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/routes.dart';
import 'package:schoolapp/views/dashboard/controller.dart';
import 'package:schoolapp/views/dashboard/widgets/slide_image.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  // Original dashboard menu order:
  // 0 Payment, 1 Attendance, 2 Request Leave, 3 Schedule, 4 Standings,
  // 5 Attendance Log, 6 Student Report, 7 Class Activity, 8 Online Course.
  final List<String> _catName = [
    "បង់ថ្លៃសិក្សា",
    "ពិនិត្យវត្តមាន",
    "ស្នើរសុំច្បាប់",
    "កាលវិភាគសិក្សា",
    "តារាងពិន្ទុ",
    "កំណត់ត្រាវត្តមាន",
    "របាយការណ៍សិស្ស",
    "សកម្មភាពក្នុងថ្នាក់",
    "វគ្គសិក្សាអនឡាយ",
  ];

  final List<String> catIconPaths = [
    'assets/images/icon/payment.png',
    'assets/images/icon/attendance.png',
    'assets/images/icon/attendance_leave.png',
    'assets/images/icon/time_table.png',
    'assets/images/icon/score.png',
    'assets/images/icon/list_attendance.png',
    'assets/images/icon/student_report.png',
    'assets/images/icon/class_activity.png',
    'assets/images/icon/online_course.png',
  ];

  final Color _panelColor = const Color(0xFFFFFFFF);
  final Color _iconBgColor = const Color(0xFFDDE8EE);

  final List<String> bannerImages = [
    'assets/images/sliver_banner.png',
    'assets/images/playground.jpg',
    'assets/images/sliver_banner.png',
    'assets/images/activity.png',
  ];

  DashboardController controller = Get.find<DashboardController>();

  List<int> _visibleMenuIndices() {
    final isParent = UserRepository.shared.isDriver;
    if (isParent) {
      return List<int>.generate(_catName.length, (i) => i);
    }
    // Teacher view order requested by user.
    return const [5, 2, 3, 4, 7, 8];
  }

  void click(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.paymentCollection);
        break;
      case 1:
        Get.toNamed(Routes.attendance);
        break;
      case 2:
        Get.toNamed(Routes.allRequestLeave);

        break;
      case 3:
        Get.toNamed(Routes.schedule);

        break;
      case 4:
        Get.toNamed(Routes.standings);
        break;
      case 5:
        Get.toNamed(Routes.attendanceRecord);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final visibleMenuIndices = _visibleMenuIndices();
        final visibleCount = visibleMenuIndices.length;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final bottomNavOverlay = MediaQuery.of(context).padding.bottom + 84.0;
        final usableHeight = (height - bottomNavOverlay).clamp(420.0, 2000.0);
        final crossAxisCount =
            width >= 900
                ? 5
                : width >= 700
                ? 4
                : 3;
        // Keep visual size consistent with original 9-tile dashboard,
        // even when role-based filtering shows fewer items.
        final rows = (_catName.length / crossAxisCount).ceil();

        final sliderHeight =
            usableHeight < 620
                ? 132.0
                : width >= 700
                ? 196.0
                : 162.0;
        const topGap = 10.0;
        const middleGap = 8.0;
        const bottomPadding = 10.0;
        const gridPaddingVertical = 20.0;
        const mainSpacing = 12.0;
        final spacingTotal = (rows - 1) * mainSpacing;
        final remaining =
            usableHeight -
            sliderHeight -
            topGap -
            middleGap -
            bottomPadding -
            gridPaddingVertical -
            spacingTotal;
        final tileHeight = (remaining / rows).clamp(102.0, 165.0);
        final iconSize = (tileHeight * 0.42).clamp(48.0, 62.0);
        final labelFontSize = (tileHeight * 0.108).clamp(12.0, 15.0);

        return Column(
          children: [
            SizedBox(height: topGap),
            SizedBox(
              height: sliderHeight,
              child: PremiumSlider(imagesList: bannerImages),
            ),
            const SizedBox(height: middleGap),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: _panelColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
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
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    12,
                    4,
                    12,
                    16 + bottomNavOverlay,
                  ),
                  itemCount: visibleCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: tileHeight,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: mainSpacing,
                  ),
                  itemBuilder: (context, index) {
                    final itemIndex = visibleMenuIndices[index];
                    return InkWell(
                      onTap: () => click(itemIndex),
                      borderRadius: BorderRadius.circular(12),
                      child: LayoutBuilder(
                        builder: (context, itemConstraints) {
                          final itemHeight = itemConstraints.maxHeight;
                          final itemIconSize = (itemHeight * 0.54).clamp(
                            58.0,
                            iconSize + 14,
                          );
                          final itemGap = (itemHeight * 0.06).clamp(4.0, 8.0);
                          final itemFontSize = (itemHeight * 0.108).clamp(
                            12.0,
                            labelFontSize,
                          );

                          return Column(
                            children: [
                              Container(
                                height: itemIconSize,
                                width: itemIconSize,
                                decoration: BoxDecoration(
                                  color: _iconBgColor,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _menuIcon(
                                    catIconPaths[itemIndex],
                                    (itemIconSize * 0.56).clamp(34.0, 40.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: itemGap),
                              Expanded(
                                child: Text(
                                  _catName[itemIndex],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: itemFontSize,
                                    height: 1.15,
                                    color: const Color(0xFF1F2A37),
                                    fontFamily: 'Battambang',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _menuIcon(String path, double size) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      cacheWidth: 128,
      cacheHeight: 128,
      errorBuilder:
          (_, __, ___) => const Icon(
            Icons.apps_rounded,
            size: 30,
            color: Color(0xFF0B5A57),
          ),
    );
  }
}
