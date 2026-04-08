import 'package:flutter/material.dart';
import 'package:swis_school/core/core.dart';

enum SingingCharacter { lafayette, jefferson, las }

class PaymentCardWidget extends StatelessWidget {
  final SingingCharacter _character = SingingCharacter.lafayette;

  PaymentCardWidget({super.key});

  final List<List<String>> data = [
    ['១', 'ជាផ្នែកនៃទំនាក់ទំនងសង្គម', '09/09/2012', 'មានការទទួល', ''],
    ['២', 'ជាផ្នែកនៃទំនាក់ទំនងសង្គមជាក់ស្តែង', '09/09/2012', 'មានការទទួល'],
    ['៣', 'ជាផ្នែកនៃទំនាក់ទំនងបច្ចុប្បន្ន', '09/09/2012', 'បាត់បង់'],
    ['៤', 'ជាផ្នែកនៃទំនាក់ទំនងសង្គម', '09/09/2012', 'បាត់បង់'],
    ['៥', 'ជាផ្នែកនៃទំនាក់ទំនងសង្គមជាក់ស្តែង', '09/09/2012', 'បាត់បង់'],
    ['៦', 'ជាផ្នែកនៃទំនាក់ទំនងបច្ចុប្បន្ន', '09/09/2012', 'បាត់បង់'],
    ['៧', 'ជាផ្នែកនៃទំនាក់ទំនងសង្គម', '09/09/2012', 'បាត់បង់'],
    ['៨', 'ជាផ្នែកនៃទំនាក់ទំនងសង្គមជាក់ស្តែង', '09/09/2012', 'បាត់បង់'],
    ['៩', 'ជាផ្នែកនៃទំនាក់ទំនងបច្ចុប្បន្ន', '09/09/2012', 'បាត់បង់'],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "១. ព័ត៌មាននៃការបង់ថ្លៃសិក្សាបន្ទាប់",
              style: AppTextStyle.smallPrimaryBold,
            ),
            const SizedBox(height: 8),
            Card.outlined(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset('assets/images/student_card.png', width: 60),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRadioOption(
                            character: SingingCharacter.lafayette,
                            groupValue: _character,
                            title: 'ថ្នាក់ចំណោះទូទៅភាសាខ្មែរ',
                            subtitle: 'ថ្នាក់ទី១ក វេនព្រឹក',
                          ),
                          _buildRadioOption(
                            character: SingingCharacter.jefferson,
                            groupValue: _character,
                            title: 'ថ្នាក់ចំណោះទូទៅភាសាអង់គ្លេស',
                            subtitle: 'កម្រិត Level2',
                          ),
                          _buildRadioOption(
                            character: SingingCharacter.las,
                            groupValue: _character,
                            title: 'ថ្នាក់ចំណោះទូទៅភាសាចិន',
                            subtitle: 'កម្រិត Level2',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "២. ប្រវត្តិនៃការបង់ថ្លៃសិក្សាកូនៗរបស់លោកអ្នក",
              style: AppTextStyle.smallPrimaryBold,
            ),
            const SizedBox(height: 8),
            Card.outlined(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderRow(),
                  const Divider(height: 1),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 1),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final isEven = index % 2 == 0;
                      return Container(
                        color:
                            isEven
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            _buildCell(data[index][0], flex: 1),
                            _buildCell(data[index][1], flex: 3),
                            _buildCell(data[index][2], flex: 2),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required SingingCharacter character,
    required SingingCharacter? groupValue,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Radio<SingingCharacter>(
          value: character,
          groupValue: groupValue,
          onChanged: (_) {},
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      color: AppColor.white,
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Text('ល.រ', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ប្រភេទសកម្មភាព',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'កាលបរិច្ជេក',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ស្ថានភាព',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              'បង្កាន់ដៃ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyle.smallPrimaryRegular.copyWith(fontSize: 10),
      ),
    );
  }
}
