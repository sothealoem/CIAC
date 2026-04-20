import 'package:swis_school/views/all_requested_leave/all_requested_leave.dart';
import 'package:swis_school/views/request_leave/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';

class StudentCardWidget extends StatelessWidget {
  const StudentCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestLeaveController());
    //final controller = Get.find<RequestLeaveController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: 5.padAll,
            margin: 5.padAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TITLE
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "១.ជ្រើសរើសថ្នាក់រៀនកូនៗដែlលោកអ្នកចង់ស្នើសុំច្បាប់",
                        style: AppTextStyle.mediumPrimaryBoldText,
                      ),
                    ),
                  ],
                ),

                /// CARD 1
                Card.outlined(
                  color: AppColor.white,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        /// LEFT
                        Column(
                          children: [
                            Container(
                              width: 90,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/images/studentprofile.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text("សិន ដារ៉ា"),
                            const Text(
                              "សិស្ស",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        /// RIGHT (❌ removed Expanded)
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "អត្តលេខ",
                                style: AppTextStyle.regularPrimaryBoldblack,
                              ),
                              const SizedBox(height: 6),
                              _buildInput("#235690"),

                              const SizedBox(height: 12),

                              const Text(
                                "ថ្នាក់ទី",
                                style: AppTextStyle.regularPrimaryBoldblack,
                              ),
                              const SizedBox(height: 6),
                              _buildDropdown(),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "វេន",
                                    style: AppTextStyle.regularPrimaryBoldblack,
                                  ),
                                  _buildRadio("ព្រឹក"),
                                  _buildRadio("រសៀល"),
                                  _buildRadio("ល្ងាច"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// TITLE 2
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Text(
                        "២.បំពេញព័ត៌មានអំពីសំណើរសុំច្បាប់របស់លោកអ្នក",
                        style: AppTextStyle.mediumPrimaryBoldText,
                      ),
                    ),
                  ],
                ),

                /// CARD 2
                Card.outlined(
                  color: AppColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        ///Duration day leave
                        Obx(() {
                          final controller = Get.find<RequestLeaveController>();

                          return Row(
                            children: [
                              Text(
                                'ចំនួនឈប់សម្រាក៖',
                                style: AppTextStyle.smallPrimaryBoldBlack,
                              ),
                              5.width,
                              Container(
                                width: 70,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.black45),
                                ),
                                child: Text(
                                  controller.totalDays == 0
                                      ? ""
                                      : controller.totalDays.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          );
                        }),
                        10.height,

                        /// START DATE
                        Row(
                          children: [
                            Text(
                              'សម្រាកពីថ្ងៃទី៖',
                              style: AppTextStyle.smallPrimaryBoldBlack,
                            ),
                            5.width,
                            Expanded(
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: Colors.black45,
                                        ),
                                      ),
                                      child: Text(
                                        controller.startDate.value,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: controller.pickStartDate,
                                      child: const Icon(Icons.date_range),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Text(
                              'ដល់ថ្ងៃ៖',
                              style: AppTextStyle.smallPrimaryBoldBlack,
                            ),
                            5.width,
                            Expanded(
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: Colors.black45,
                                        ),
                                      ),
                                      child: Text(
                                        controller.endDate.value,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: controller.pickEndDate,
                                      child: const Icon(Icons.date_range),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),

                        10.height,

                        /// LEAVE TYPE
                        Row(
                          children: [
                            Text(
                              'មូលហេតុ៖ ',
                              style: AppTextStyle.smallPrimaryBoldBlack,
                            ),
                            10.width,
                            _buildLeaveType('ឈឺ'),
                            20.width,
                            _buildLeaveType('រវល់'),
                            20.width,
                            _buildLeaveType('ផ្សេងៗ'),
                          ],
                        ),

                        10.height,

                        /// REASON
                        TextFormField(
                          style: AppTextStyle.smallPrimaryBoldBlack,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'មូលហេតុផ្សេងៗ....',
                            labelStyle: AppTextStyle.smallPrimaryBoldBlack,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                UIConstants.spacing.height,

                /// BUTTON
                Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F6B5B), // your green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed:
                        controller.isloading.value
                            ? null
                            : () async {
                              await controller.submitRequest();
                              Get.back();
                              Get.snackbar(
                                "Success",
                                "Request submitted",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              //Get.off(() => const AllRequestedLeaveView());
                            },
                    child:
                        controller.isloading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(LocaleKeys.send.tr),
                  );
                }),
                // PrimaryButton(
                //   text: LocaleKeys.send.tr,
                //   onPressed: () {
                //     print("Class: ${controller.selectedClass.value}");
                //     print("Shift: ${controller.selectedShift.value}");
                //     print("Date: ${controller.startDate.value}");
                //     print("Leave: ${controller.leaveType.value}");
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// INPUT
  Widget _buildInput(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Text(text),
    );
  }

  /// DROPDOWN
  Widget _buildDropdown() {
    final controller = Get.find<RequestLeaveController>();

    return Obx(() {
      return GestureDetector(
        onTap: () async {
          final value = await showModalBottomSheet<String>(
            context: Get.context!,
            builder:
                (_) => ListView(
                  children:
                      controller.classes
                          .map(
                            (e) => ListTile(
                              title: Text(e),
                              onTap: () => Get.back(result: e),
                            ),
                          )
                          .toList(),
                ),
          );
          if (value != null) controller.selectedClass.value = value;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedClass.value,
                style: AppTextStyle.smallPrimaryBoldBlack,
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      );
    });
  }

  /// RADIO SHIFT
  Widget _buildRadio(String title) {
    final controller = Get.find<RequestLeaveController>();

    return Obx(() {
      final isSelected = controller.selectedShift.value == title;

      return GestureDetector(
        onTap: () => controller.selectedShift.value = title,
        child: Column(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.teal : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyle.smallPrimaryBoldBlack),
          ],
        ),
      );
    });
  }

  /// LEAVE TYPE
  Widget _buildLeaveType(String title) {
    final controller = Get.find<RequestLeaveController>();

    return Obx(() {
      final isSelected = controller.leaveType.value == title;

      return GestureDetector(
        onTap: () => controller.leaveType.value = title,
        child: Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black45),
                color: isSelected ? Colors.teal : Colors.transparent,
              ),
            ),
            5.width,
            Text(title, style: AppTextStyle.smallPrimaryBoldBlack),
          ],
        ),
      );
    });
  }
}
