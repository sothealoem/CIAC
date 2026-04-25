import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/models/requestleave/model.dart';
import 'package:schoolapp/views/request_leave/controller.dart';
import 'package:schoolapp/views/request_leave/view.dart';
import 'package:schoolapp/views/all_requested_leave/widget/custom_tab.dart';

class AllRequestedCard extends StatefulWidget {
  const AllRequestedCard({super.key});

  @override
  State<AllRequestedCard> createState() => _AllRequestedCardState();
}

class _AllRequestedCardState extends State<AllRequestedCard> {
  int selectedIndex = 0;
  // Get the existing controller instance
  final controller = Get.put(RequestLeaveController());

  List<RequestLeaveModel> getFilteredList() {
    final all = controller.requests;
    if (selectedIndex == 0) return all;
    if (selectedIndex == 1)
      return all.where((e) => e.status == "pending").toList();
    if (selectedIndex == 2)
      return all.where((e) => e.status == "approved").toList();
    return all.where((e) => e.status == "rejected").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CustomTopTabBar(
              selectedIndex: selectedIndex,
              onChanged: (index) => setState(() => selectedIndex = index),
            ),
            Expanded(
              child: Obx(() {
                //final list = getFilteredList();
                List<RequestLeaveModel> list = [];

                if (selectedIndex == 0) {
                  list = controller.requests.toList();
                } else if (selectedIndex == 1) {
                  list =
                      controller.requests
                          .where((e) => e.status == "pending")
                          .toList();
                } else if (selectedIndex == 2) {
                  list =
                      controller.requests
                          .where((e) => e.status == "approved")
                          .toList();
                } else {
                  list =
                      controller.requests
                          .where((e) => e.status == "rejected")
                          .toList();
                }
                if (list.isEmpty)
                  return const Center(child: Text("គ្មានទិន្នន័យ"));

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: list.length,
                  itemBuilder: (context, index) => _buildCard(list[index]),
                );
              }),
            ),
          ],
        ),

        // Floating Action Button
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF0F6B5B),
            onPressed: () => Get.to(() => const RequestLeaveView()),
            label: const Text(
              "ស្នើសុំច្បាប់",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(RequestLeaveModel item) {
    Color statusColor =
        item.status == "approved"
            ? Colors.green
            : (item.status == "rejected" ? Colors.red : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status ?? "",
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "ថ្នាក់ទី: ${item.grade} | ថ្ងៃឈប់: ${item.dateStart} - ${item.dateEnd}",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),

          // Reason Box with Label
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.reason ?? "",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Positioned(
                top: 0,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  color: Colors.grey.shade100,
                  child: const Text(
                    "មូលហេតុ",
                    style: TextStyle(fontSize: 10, color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
