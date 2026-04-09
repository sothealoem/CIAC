import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';

enum SingingCharacters { lafayette, jefferson, las }

class StudentCardWidget extends StatelessWidget {
  final SingingCharacters _character = SingingCharacters.lafayette;

  const StudentCardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 5.padAll,
      margin: 5.padAll,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "១.ជ្រើសរើសថ្នាក់រៀនកូនៗដែlលោកអ្នកចង់ស្នើសុំច្បាប់",
                  style: AppTextStyle.mediumPrimaryBoldText,
                ),
              ),
            ],
          ),
          Card.outlined(
            color: AppColor.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor.white, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),

            child: Padding(
              padding: const EdgeInsets.all(10.0), // Inner padding for content
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/student_card.png'),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio<SingingCharacters>(
                              value: SingingCharacters.lafayette,
                              groupValue: _character,
                              onChanged: (SingingCharacters? value) {},
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'ថ្នាក់ចំណោះទូទៅភាសាខ្មែរ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'ថ្នាក់ទី១ក វេនព្រឹក',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: SingingCharacters.jefferson,
                              groupValue: _character,
                              onChanged: (SingingCharacters? value) {},
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'ថ្នាក់ចំណោះទូទៅភាសាអង់គ្លេស',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'កម្រិត Level2',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: SingingCharacters.las,
                              groupValue: _character,
                              onChanged: (SingingCharacters? value) {},
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'ថ្នាក់ចំណោះទូទៅភាសាចិន',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'កម្រិត Level2',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 10),
                child: Text(
                  "២.បំពេញព័ត៌មានអំពីសំណើរសុំច្បាប់របស់លោកអ្នក",
                  style: AppTextStyle.mediumPrimaryBoldText,
                ),
              ),
            ],
          ),
          Card.outlined(
            color: AppColor.white,
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(color: AppColor.white),
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('ចំនួនឈប់សម្រាក៖ '),
                      5.width,
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.black45),
                            ),
                          ),
                          Text(' ថ្ងៃ'),
                        ],
                      ),
                    ],
                  ),
                  10.height,
                  Row(
                    children: [
                      Text('សម្រាកពីថ្ងៃទី៖ '),
                      5.width,
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.black45),
                            ),
                          ),
                          Icon(Icons.date_range),
                        ],
                      ),
                      5.width,
                      Text('ដល់ថ្ងៃទី'),
                      5.width,
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.black45),
                            ),
                          ),
                          Icon(Icons.date_range),
                        ],
                      ),
                    ],
                  ),
                  10.height,
                  Row(
                    children: [
                      Text('មូលហេតុ៖ '),
                      10.width,
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(' ឈឺ'),
                        ],
                      ),
                      20.width,
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(' រវល់'),
                        ],
                      ),
                      20.width,
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(' ផ្សេងៗ'),
                        ],
                      ),
                    ],
                  ),
                  10.height,
                  TextFormField(
                    maxLines: 5, // or adjust based on your need
                    decoration: InputDecoration(
                      labelText:
                          'មូលហេតុផ្សេងៗ', // The label shown above the border
                      alignLabelWithHint: true, // important for multiline
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.teal,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'KhmerFont',
                    ), // Optional: apply Khmer font
                  ),
                ],
              ),
            ),
          ),
          UIConstants.spacing.height,

          Column(
            children: [
              // Login button
              PrimaryButton(text: LocaleKeys.send.tr, onPressed: () {}),

              SizedBox(height: 4.0), // Vertical spacing
              // Register text widget
              // const NoAccountWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
