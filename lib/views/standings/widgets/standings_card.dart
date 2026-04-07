import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';

enum SingingCharacter1 { lafayette, jefferson, las }

class StandingsCardWidget extends StatelessWidget {
  final SingingCharacter1 _character = SingingCharacter1.lafayette;

  const StandingsCardWidget({super.key});

  Widget _buildInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$label1:", style: AppTextStyle.normalGreyRegular),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Text(value1, style: AppTextStyle.normalPrimaryBold)],
            ),
          ),
          Flexible(
            flex: 2,
            child: SizedBox(
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$label2:", style: AppTextStyle.normalGreyRegular),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1, // Adjust flex factor as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(value2, style: AppTextStyle.normalPrimaryBold)],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 3.padAll,
      margin: 3.padAll,
      child: Column(
        children: [
          Card.outlined(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0), // Inner padding for content
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/profiles.png'),
                  10.width,
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'សម្រាប់ខែ មករា ឆ្នាំ២០២៤',
                                  style: AppTextStyle.normalGreyRegular,
                                ),
                                Text(
                                  'វៃ ករណា',
                                  style: AppTextStyle.midSecondaryBold,
                                ),
                                Text(
                                  'ថ្នាក់ចំណោះទូទៅភាសាអង់គ្លេស',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                        // Row(children: [
                        //   Radio(
                        //     value: SingingCharacter1.jefferson,
                        //     groupValue: _character,
                        //     onChanged: (SingingCharacter1? value) {
                        //     },
                        //   ),
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Text(
                        //         'ថ្នាក់ចំណោះទូទៅភាសាអង់គ្លេស',
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //       Text(
                        //         'កម្រិត Level2',
                        //         style: TextStyle(fontSize: 9, color: Colors.grey),
                        //       ),
                        //     ],
                        //   ),
                        // ],),
                        // Row(children: [
                        //   Radio(
                        //     value: SingingCharacter1.las,
                        //     groupValue: _character,
                        //     onChanged: (SingingCharacter1? value) {
                        //     },
                        //   ),
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Text(
                        //         'ថ្នាក់ចំណោះទូទៅភាសាចិន',
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //       Text(
                        //         'កម្រិត Level2',
                        //         style: TextStyle(fontSize: 9, color: Colors.grey),
                        //       ),
                        //     ],
                        //   ),
                        // ],),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Inner padding for content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("ចំណាត់ថ្នាក់", "2", "សរុបអវត្ដមាន", "0"),
                  _buildInfoRow("សិស្សសរុប", "12", "ឥតច្បាប់", "1"),
                  _buildInfoRow("មធ្យមភាគ", "8.74", "ចូលរៀនយឺត", "0"),
                  _buildInfoRow("និទ្ទេស", "ល្អប្រសើរ", "មានច្បាប់", "0"),
                ],
              ),
            ),
          ),
          // Content for Tab 3
          Card(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white70.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),

              child: DataTable(
                dataRowHeight: 40, // Adjust row height as needed
                columnSpacing: 10,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'មុខវិជ្ជា',
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ពិន្ទុ',
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ពិន្ទុអតិបរមា',
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'និទ្ទេស',
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('រៀនអាន'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '9.71',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អប្រសើរ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('រឿងនិទាន'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '8.5',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អប្រសើរ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('តែងសេចក្តី'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '9.07',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អប្រសើរ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('សរសេរតាមអាន'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '9.58',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អប្រសើរ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('មេសូត្រ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '8.98',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អប្រសើរ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('វេយ្យាករណ៏'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text('9', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('អក្សរផ្ចង់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('នព្វន្ត'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '7.78',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('មាត្រាប្រព័ន្ធ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '5.8',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('ធរណីមាត្រ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '7.7',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('វិទ្យាសាស្រ្ត'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '9.4',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('ប្រវត្តិវិទ្យា'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '8.6',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('ភូមិវិទ្យា'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text('8', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('ពលរដ្ឋ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '6.4',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('គំនូរ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '9.1',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('ចម្រៀង-របាំ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text('5', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('អង់គ្លេស'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text('8', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('កុំព្យូទ័រ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '6.8',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អ'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('កីឡា'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text(
                            '8.6',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('អប់រំកាយ'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text('7', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 100, //SET width
                          child: Text('វិន័យ សីលធម៌'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.centerLeft,
                          width: 50, //SET width
                          child: Text('8', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('10'),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.zero, // Remove padding
                          alignment: Alignment.center,
                          width: 50, //SET width
                          child: Text('ល្អណាស់'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.comment, color: Colors.black, size: 25.0),
              title: Text(
                'មូលវិចារគ្រូបន្ទុកថ្នាក់',
                style: AppTextStyle.normalPrimarySemiBold,
                textAlign: TextAlign.left,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black,
                size: 25.0,
              ),
            ),
          ),
          // Content for Tab 2
          Card(
            child: ListTile(
              leading: Icon(Icons.comment, color: Colors.black, size: 25.0),
              title: Text(
                'មតិយោបល់អ្នកអាណាព្យាបាល',
                style: AppTextStyle.normalPrimarySemiBold,
                textAlign: TextAlign.left,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
