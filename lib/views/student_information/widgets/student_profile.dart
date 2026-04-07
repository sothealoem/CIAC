import 'package:flutter/material.dart';

class StudentProfileWidget extends StatelessWidget {
  const StudentProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.network(
              'assets/images/profile.PNG',
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/profiles.png',
                  width: 150, // Adjust width as needed
                  height: 150,
                );
              },
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.zero, // Remove all margins
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),

            child: DataTable(
              columnSpacing: 10,
              horizontalMargin: 12.0,
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('លេខសម្គាល់សិស្ស៖')),
                    DataCell(Text('2023005')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('ឈ្មោះពេញ៖')),
                    DataCell(Text('កែវ ពុធលក្ខិណា')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('ថ្ងៃខែឆ្នាំកំណើត')),
                    DataCell(Text('២០ មិថុនា ២០០៤')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('ទីកន្លែងកំណើត៖')),
                    DataCell(Text('ភ្នំពេញ')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('ភេទ៖')),
                    DataCell(Text('ស្រី')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('រៀនថ្នាក់៖')),
                    DataCell(Text('ទី១ក')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('គ្រូបន្ទុកថ្នាក់៖')),
                    DataCell(Text('ចំរើន')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('អាស័យដ្ធានអាណាព្យាបាយ៖')),
                    DataCell(Text('ភ្នំពេញ')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('ទីកន្លែងបច្ចុប្បន្ន៖')),
                    DataCell(Text('ភ្នំពេញ')),
                  ],
                ),
              ],
              dividerThickness: 0, // Removes the divider between rows
            ),
          ),
        ],
      ),
    );
  }
}
