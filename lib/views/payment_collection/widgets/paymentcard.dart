import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';

enum SingingCharacter { lafayette, jefferson, las }

class PaymentCardWidget extends StatelessWidget {
  final SingingCharacter _character = SingingCharacter.lafayette;

  PaymentCardWidget({super.key});

  // Data structure updated based on the image
  final List<List<String>> data = [
    ['១', 'ថ្នាក់ចំណោះទូទៅភាសាខ្មែរ', '07/04/2025', 'បានបង់'],
    ['២', 'English Level 2', '07/04/2025', 'មិនទាន់បានបង់'],
    ['៣', 'ថ្នាក់ចំណោះទូទៅភាសាចិន', '07/04/2025', 'បានបង់'],
    ['៤', 'ថ្នាក់ចំណោះទូទៅគណិតវិទ្យា', '07/04/2025', 'មិនទាន់បានបង់'],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            const SizedBox(height: 8),
            Text(
              "១. ព័ត៌មាននៃការបង់ថ្លៃសិក្សាបន្ទាប់",
              style: AppTextStyle.mediumPrimaryBoldText,
            ),
            const SizedBox(height: 12),
            _buildStudentCard(),
            const SizedBox(height: 20),

            // History Section
            const Text(
              "២. ប្រវត្តិនៃការបង់ថ្លៃសិក្សាកូនៗរបស់លោកអ្នក",
              style: AppTextStyle.mediumPrimaryBoldText,
            ),
            const SizedBox(height: 8),
            Card.outlined(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderRow(),
                  // Divider(height: 1, color:  .greyTextColor),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final isEven = index % 2 == 0;
                      final tealBackgroundColor = const Color.fromARGB(
                        255,
                        0,
                        121,
                        107,
                      );
                      //  final rowColor = isEven ? tealBackgroundColor : Colors.transparent;
                      final contentColor =
                          isEven ? Colors.white : AppColor.primary;
                      final iconColor =
                          isEven ? Colors.white : AppColor.darkGrey;
                      // Determine background color for alternative rows based on UI
                      final rowColor =
                          isEven
                              ? const Color.fromARGB(
                                255,
                                0,
                                121,
                                107,
                              ).withOpacity(1)
                              : Colors.transparent;
                      return Container(
                        color: rowColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            _buildCell(
                              data[index][0],
                              flex: 1,
                              textColor: contentColor,
                              centerText: true,
                            ),
                            _buildCell(
                              data[index][1],
                              flex: 4,
                              leftPadding: true,
                              textColor: contentColor,
                            ),
                            _buildCell(
                              data[index][2],
                              flex: 3,
                              textColor: contentColor,
                            ),
                            _buildCell(
                              data[index][3],
                              flex: 3,
                              textColor: contentColor,
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.file_download_outlined,
                                size: 20,
                                color: iconColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Total amount card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColor.primaryColor,
              child: const Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    'សរុបប្រាក់ដែលត្រូវបង់ : 150.00\$',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Battambang',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the student card section
  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Student Info Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // Replace with your actual student card image asset
                child: Image.asset(
                  'assets/images/event.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              const Text('សិន ដារ៉ា'),
              const Text(
                'សិស្ស',
                style: TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 12,
                  fontFamily: 'Battambang',
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeeOption(
                  character: SingingCharacter.lafayette,
                  groupValue: _character,
                  title: 'ថ្នាក់ចំណោះទូទៅភាសាខ្មែរ',
                  subtitle: 'ថ្នាក់ទី១ក វេនព្រឹក',
                  price: '150.00\$',
                  date: '7/21/25',
                ),
                _buildFeeOption(
                  character: SingingCharacter.jefferson,
                  groupValue: _character,
                  title: 'ថ្នាក់ចំណោះទូទៅភាសាអង់គ្លេស',
                  subtitle: 'កម្រិត Level 2',
                  price: '0.00\$',
                  date: '7/21/25',
                ),
                _buildFeeOption(
                  character: SingingCharacter.las,
                  groupValue: _character,
                  title: 'ថ្នាក់ចំណោះទូទៅគណិតវិទ្យា',
                  subtitle: 'កម្រិត Level 2',
                  price: '0.00\$',
                  date: '7/21/25',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeOption({
    required SingingCharacter character,
    required SingingCharacter? groupValue,
    required String title,
    required String subtitle,
    required String price,
    required String date,
  }) {
    final bool isSelected = false;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 48),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Battambang',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColor.greyTextColor,
                      fontSize: 10,
                      fontFamily: 'Battambang',
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateTag(date),
                      Text(
                        price,

                        style: TextStyle(
                          fontFamily: 'Battambang',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Helper to build the date tag (e.g., 7/21/25)
  Widget _buildDateTag(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // color: _primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        date,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Battambang',
        ),
      ),
    );
  }

  // Re-implemented header row to match image column widths
  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(flex: 1, child: _buildHeaderCell('ល.រ', centerText: true)),
          Expanded(
            flex: 4,
            child: _buildHeaderCell('ប្រភេទការសិក្សា', leftPadding: true),
          ),
          Expanded(flex: 3, child: _buildHeaderCell('កាលបរិច្ជេក')),
          Expanded(flex: 3, child: _buildHeaderCell('ស្ថានភាព')),
          Expanded(
            flex: 1,
            child: _buildHeaderCell('បង្កាន់ដៃ', centerText: true),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    bool centerText = false,
    bool leftPadding = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding ? 12.0 : 0),
      child: Text(
        text,
        textAlign: centerText ? TextAlign.center : TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Battambang',
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    required int flex,
    bool centerText = false,
    bool leftPadding = false,
    Color? textColor,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding ? 12.0 : 0),
        child: Text(
          text,
          textAlign: centerText ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontFamily: 'Battombang',
            fontSize: 12,
            color: textColor ?? AppColor.primary,
          ),
        ),
      ),
    );
  }
}
