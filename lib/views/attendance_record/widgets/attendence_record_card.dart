import 'package:swis_school/views/attendance_record/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendenceRecordCardWidget extends StatelessWidget {
  AttendenceRecordCardWidget({super.key});

  final controller = Get.find<AttendanceRecordController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          /// =========================
          /// 📅 DATE PICKER
          /// =========================
          Obx(() {
            return GestureDetector(
              onTap: () => controller.pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedDate.value.isEmpty
                            ? "Select Date"
                            : controller.selectedDate.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.calendar_month_rounded, size: 18),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          /// =========================
          /// 🔽 FILTER ROW
          /// =========================
          Row(
            children: [
              Expanded(child: _buildDropdown("ថ្នាក់ទី")),
              const SizedBox(width: 10),

              GestureDetector(
                onTap: controller.filter,
                child: _buildButton("Filter", Colors.amber, Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// =========================
          /// 🔽 RESET ROW
          /// =========================
          Row(
            children: [
              Expanded(child: _buildDropdown("ជ្រើសរើស")),
              const SizedBox(width: 10),

              GestureDetector(
                onTap: controller.reset,
                child: _buildButton(
                  "Reset",
                  Colors.grey.shade400,
                  Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// =========================
          /// 📋 ATTENDANCE LIST
          /// =========================
          Obx(() {
            return Column(
              children:
                  controller.attendanceList.map((item) {
                    return _buildCard(item);
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  // =========================
  // 🔹 CARD
  // =========================
  Widget _buildCard(Map item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(item['date'] ?? ''),
            ),
          ),

          const SizedBox(height: 10),

          /// NAME + STATUS
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/teacher.jpg'),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  item['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      item['status'] == "present"
                          ? Colors.green
                          : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['status'] == "present" ? "គ្រប់" : "យឺត",
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TIME (COLUMN STYLE)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ចូលម៉ោង ${item['checkInMorning']}"),
              const SizedBox(height: 4),
              Text("ចេញម៉ោង ${item['checkOutMorning']}"),

              const SizedBox(height: 6),
              Divider(color: Colors.grey.shade300),

              const SizedBox(height: 6),
              Text("ចូលម៉ោង ${item['checkInAfternoon']}"),
              const SizedBox(height: 4),
              Text("ចេញម៉ោង ${item['checkOutAfternoon']}"),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // 🔹 DROPDOWN
  // =========================
  Widget _buildDropdown(String hint) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(fontSize: 13)),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  // =========================
  // 🔹 BUTTON
  // =========================
  Widget _buildButton(String text, Color bg, Color textColor) {
    return Container(
      height: 44,
      width: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
