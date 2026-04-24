import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/views/request_leave/controller.dart';

class StudentCard1Widget extends StatelessWidget {
  const StudentCard1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestLeaveController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: 5.padAll,
            margin: 5.padAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// SECTION 1: STUDENT INFO
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
                              _buildDropdown(controller),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "វេន",
                                    style: AppTextStyle.regularPrimaryBoldblack,
                                  ),
                                  _buildRadio(controller, "ព្រឹក"),
                                  _buildRadio(controller, "រសៀល"),
                                  _buildRadio(controller, "ល្ងាច"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// SECTION 2: LEAVE DETAILS
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

                Card.outlined(
                  color: AppColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Obx(
                          () => Row(
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
                          ),
                        ),
                        10.height,
                        Row(
                          children: [
                            Text(
                              'សម្រាកពីថ្ងៃទី៖',
                              style: AppTextStyle.smallPrimaryBoldBlack,
                            ),
                            5.width,
                            Expanded(
                              child: Obx(
                                () => Row(
                                  children: [
                                    _dateBox(controller.startDate.value),
                                    GestureDetector(
                                      onTap: controller.pickStartDate,
                                      child: const Icon(Icons.date_range),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'ដល់ថ្ងៃ៖',
                              style: AppTextStyle.smallPrimaryBoldBlack,
                            ),
                            5.width,
                            Expanded(
                              child: Obx(
                                () => Row(
                                  children: [
                                    _dateBox(controller.endDate.value),
                                    GestureDetector(
                                      onTap: controller.pickEndDate,
                                      child: const Icon(Icons.date_range),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.height,
                        Row(
                          children: [
                            Text(
                              'មូលហេតុ៖ ',
                              style: AppTextStyle.smallPrimaryBoldBlack,
                            ),
                            10.width,
                            _buildLeaveType(controller, 'ឈឺ'),
                            20.width,
                            _buildLeaveType(controller, 'រវល់'),
                            20.width,
                            _buildLeaveType(controller, 'ផ្សេងៗ'),
                          ],
                        ),
                        10.height,
                        TextFormField(
                          controller:
                              controller
                                  .reasonController, // BINDING TO CONTROLLER
                          style: AppTextStyle.smallPrimaryBoldBlack,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'មូលហេតុផ្សេងៗ....',
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

                /// SUBMIT BUTTON
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F6B5B),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        controller.isloading.value
                            ? null
                            : () async {
                              await controller.submitRequest();
                              Navigator.of(context).pop();
                              // Get.back();
                              // Get.snackbar(
                              //   "ជោគជ័យ",
                              //   "សំណើរបស់លោកអ្នកត្រូវបានបញ្ជូន",
                              //   backgroundColor: Colors.green,
                              //   colorText: Colors.white,
                              // );
                            },
                    child:
                        controller.isloading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(LocaleKeys.send.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateBox(String text) => Container(
    width: 70,
    height: 20,
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      border: Border.all(color: Colors.black45),
    ),
    child: Text(text, style: const TextStyle(fontSize: 10)),
  );

  Widget _buildInput(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.teal),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    child: Text(text),
  );

  Widget _buildDropdown(RequestLeaveController controller) => Obx(
    () => GestureDetector(
      onTap: () async {
        final value = await Get.bottomSheet(
          Container(
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
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
            Text(controller.selectedClass.value),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    ),
  );

  Widget _buildRadio(RequestLeaveController controller, String title) =>
      Obx(() {
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

  Widget _buildLeaveType(RequestLeaveController controller, String title) =>
      Obx(() {
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
