import 'package:flutter/material.dart';
import 'package:ciac_school/core/core.dart';

class ScheduleCardWidget extends StatefulWidget {
  const ScheduleCardWidget({super.key});

  @override
  State<ScheduleCardWidget> createState() => _ScheduleCardWidgetState();
}

class _ScheduleCardWidgetState extends State<ScheduleCardWidget> {
  int selectedDayIndex = 0;
  final List<String> days = [
    'ចន្ទ',
    'អង្គារ',
    'ពុធ',
    'ព្រហស្បតិ៍',
    'សុក្រ',
    'សៅរ៍',
    'អាទិត្យ',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ថ្នាក់ទីមួយ ក',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'battambang',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Day Selector Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(days.length, (index) {
              bool isSelected = selectedDayIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedDayIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              isSelected
                                  ? AppColor.primaryColor
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      days[index],
                      style: TextStyle(
                        fontFamily: 'Battambang',
                        fontSize: 14,
                        color: isSelected ? AppColor.primaryColor : Colors.grey,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Divider(height: 1.2),
        ),
        // Schedule List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildClassItem(
                session: "ម៉ោងទី ១",
                time: "07:00 - 9:05 ព្រឹក",
                subject: "គណិតវិទ្យា",
                teacher: "ហេង ដារ៉ា",
                room: "០១",
              ),
              _buildClassItem(
                session: "ម៉ោងទី ២",
                time: "09:15 - 10:05 ព្រឹក",
                subject: "ភាសាខ្មែរ",
                teacher: "ពេជ្រ រស្មី",
                room: "០៨",
              ),
              _buildBreakTimeItem(timeRange: "11:00 ព្រឹក → 1:00 រសៀល"),
              _buildClassItem(
                session: "ម៉ោងទី ៣",
                time: "10:15 - 11:00 ព្រឹក",
                subject: "ភាសាអង់គ្លេស",
                teacher: "វ៉ាន់ ដា",
                room: "០៥",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for standard class slots
  Widget _buildClassItem({
    required String session,
    required String time,
    required String subject,
    required String teacher,
    required String room,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Session and Time
          SizedBox(
            width: 102,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session, style: AppTextStyle.mendiumPrimary),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: .0),
                    Expanded(
                      child: Text(time, style: AppTextStyle.smallPrimarytext),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 3.0),
          // Right Side: Card Detail
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: 40,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),

                // 2. The Main Content Card
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7F9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // Inner accent (Optional: remove this if the Stack bar is enough)
                          // Container(
                          //   width: 10,
                          //   decoration: const BoxDecoration(
                          //     color: Color(0xFF006D5B),
                          //     borderRadius: BorderRadius.only(
                          //       topLeft: Radius.circular(15),
                          //       bottomLeft: Radius.circular(15),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ម៉ោង : $subject",
                                    style: AppTextStyle.mendiumPrimaryBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "លោកគ្រូ : $teacher  |  បន្ទប់ $room",
                                    style: AppTextStyle.mendiumPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the green break time bar
  Widget _buildBreakTimeItem({required String timeRange}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,

        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(
            "ម៉ោងសម្រាក | $timeRange",
            style: AppTextStyle.mendiumPrimaryBoldwhite,
          ),
        ],
      ),
    );
  }
}

//------------------- UI Schedule old version Need Later----------------------//
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:ciac_school/core/core.dart';

// enum SingingCharacter2 { lafayette, jefferson, las }

// class ScheduleCardWidget extends StatelessWidget {
//   const ScheduleCardWidget({super.key});

//   Widget _buildInfoRow(
//     String label,
//     String value,
//     String label1,
//     String value1,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text("$label:", style: AppTextStyle.normalGreyRegular),
//           const SizedBox(width: 8.0),
//           Flexible(child: Text(value, style: const TextStyle(fontSize: 16.0))),
//           Text("$label1:", style: AppTextStyle.normalGreyRegular),
//           const SizedBox(width: 8.0),
//           Flexible(child: Text(value1, style: const TextStyle(fontSize: 16.0))),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: 5.padAll,
//       margin: 5.padAll,
//       child: Card(
//         child: Container(
//           // Adjust the height as needed
//           decoration: BoxDecoration(color: Colors.white),
//           child: Column(
//             children: [
//               // Card(
//               //   child: Image.asset('assets/images/schedule.png'),
//               // ),]
//               SizedBox(
//                 width: 300,
//                 height: 200,
//                 child: PhotoView(
//                   imageProvider: AssetImage('assets/images/schedule.png'),
//                   minScale: PhotoViewComputedScale.contained,
//                   maxScale: PhotoViewComputedScale.covered * 0.3,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8, left: 10),
//                     child: Text(
//                       "សម្រាប់ព័ត៌មានបន្ថែម៖",
//                       style: AppTextStyle.smallPrimaryBold,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8, left: 10),
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.phone, size: 14),
//                         SizedBox(width: 8.0),
//                         Text(
//                           "078 358 272 / 096 250 1328",
//                           style: AppTextStyle.smallGreyRegular,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8, left: 10),
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.email, size: 14),
//                         SizedBox(width: 8.0),
//                         Text(
//                           "info@softcreative.biz៖",
//                           style: AppTextStyle.smallGreyRegular,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8, left: 10),
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.web_asset, size: 14),
//                         SizedBox(width: 8.0),
//                         Text(
//                           "www.softcreative.biz៖",
//                           style: AppTextStyle.smallGreyRegular,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle button press
//                         print('Button pressed');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: AppColor.primaryBtn, // Text color
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ), // Button padding
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                             8,
//                           ), // Button border radius
//                         ),
//                       ),
//                       child: Text(
//                         'For More Information',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               10.height,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
