import 'package:swis_school/models/requestleave/model.dart';
import 'package:swis_school/views/all_requested_leave/widget/custom_tab.dart';
import 'package:swis_school/views/request_leave/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllRequestedCard extends StatefulWidget {
  const AllRequestedCard({super.key});

  @override
  State<AllRequestedCard> createState() => _AllRequestedCardState();
}

class _AllRequestedCardState extends State<AllRequestedCard> {
  int selectedIndex = 0;

  final List<RequestLeaveModel> allRequests = [
    RequestLeaveModel(
      name: "បញ្ពា",
      grade: '៣​ ក',
      dateStart: "07-05-2026",
      dateEnd: "08-05-2026",
      reason: "មានការងារផ្ទាល់ខ្លួន ",
      status: "pending",
    ),
    RequestLeaveModel(
      name: "បញ្ពា",
      grade: '៣​ ក',
      dateStart: "07-05-2026",
      dateEnd: "08-05-2026",
      reason: "មានការងារផ្ទាល់ខ្លួន",
      status: "approved",
    ),
    RequestLeaveModel(
      name: "បញ្ពា",
      grade: '៣​ ក',
      dateStart: "07-05-2026",
      dateEnd: "08-05-2026",
      reason: "មានការងារផ្ទាល់ខ្លួន",
      status: "rejected",
    ),
  ];

  List<RequestLeaveModel> getFilteredList() {
    if (selectedIndex == 0) return allRequests;
    if (selectedIndex == 1) {
      return allRequests.where((e) => e.status == "pending").toList();
    }
    if (selectedIndex == 2) {
      return allRequests.where((e) => e.status == "approved").toList();
    }
    return allRequests.where((e) => e.status == "rejected").toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = getFilteredList();

    // @override
    // Widget build(BuildContext context) {
    //   final list = getFilteredList();

    return Stack(
      children: [
        /// 🔹 MAIN CONTENT
        Column(
          children: [
            CustomTopTabBar(
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildCard(list[index]);
                },
              ),
            ),
          ],
        ),

        /// 🔹 BUTTON (BOTTOM RIGHT ✅)
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Get.to(() => const RequestLeaveView());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F6B5B),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "ស្នើសុំច្បាប់",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildCard(RequestLeaveModel item) {
  Color color;

  switch (item.status) {
    case "approved":
      color = Colors.green;
      break;
    case "rejected":
      color = Colors.red;
      break;
    default:
      color = Colors.orange;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 NAME + GRADE + STATUS (FIXED ROW)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  item.name!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                const Text("·"),
                const SizedBox(width: 4),
                Text(item.grade!),
              ],
            ),

            /// STATUS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(129, 199, 198, 198),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.status!,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// 🔹 DATE ROW
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 16),
            const SizedBox(width: 6),
            Text("${item.dateStart}"),
            const SizedBox(width: 6),
            const Text("ដល់ថ្ងៃ"),
            const SizedBox(width: 6),
            Text("${item.dateEnd}"),
          ],
        ),

        const SizedBox(height: 10),

        /// 🔹 REASON BOX (WITH LABEL LIKE UI)
        Stack(
          clipBehavior: Clip.none, // IMPORTANT
          children: [
            /// 🔹 MAIN BOX
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10), // space for label
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 1.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(item.reason!, style: const TextStyle(fontSize: 13)),
            ),

            /// 🔹 FLOATING LABEL (FIXED)
            Positioned(
              top: 0,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // SAME as card background
                  border: Border.all(color: Colors.teal, width: 1.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "មូលហេតុ",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
