import 'package:flutter/material.dart';

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
                  border: Border.all(color: const Color(0xFF006D5B)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ថ្នាក់ទីមួយ ក',
                  style: TextStyle(
                    color: Color(0xFF006D5B),
                    fontWeight: FontWeight.bold,
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            isSelected
                                ? const Color(0xFF006D5B)
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    days[index],
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF006D5B) : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 1),
        // Schedule List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildClassItem(
                session: "ម៉ោងទី១",
                time: "7:00 - 9:05 ព្រឹក",
                subject: "គណិតវិទ្យា",
                teacher: "ហេង",
                room: "០១",
              ),
              _buildClassItem(
                session: "ម៉ោងទី២",
                time: "9:15 - 10:05 ព្រឹក",
                subject: "ភាសាខ្មែរ",
                teacher: "ហុង",
                room: "០១",
              ),
              _buildBreakTimeItem(timeRange: "11:00 ព្រឹក → 1:00 រសៀល"),
              _buildClassItem(
                session: "ម៉ោងទី៣",
                time: "10:15 - 11:00 ព្រឹក",
                subject: "ភាសាអង់គ្លេស",
                teacher: "ហាក់",
                room: "០១",
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Session and Time
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Right Side: Card Detail
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF006D5B),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ម៉ោង : $subject",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "លោកគ្រូ : $teacher  |  បន្ទប់ $room",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
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
    );
  }

  // Widget for the green break time bar
  Widget _buildBreakTimeItem({required String timeRange}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF006D5B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(
            "ម៉ោងសម្រាក | $timeRange",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:swis_school/core/core.dart';

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
