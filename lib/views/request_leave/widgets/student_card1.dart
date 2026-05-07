import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:schoolapp/views/request_leave/controller.dart';

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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.requestLeaveSelectStudent.tr,
                      style: AppTextStyle.mediumPrimaryBoldText,
                      softWrap: true,
                    ),
                  ),
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
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Obx(
                                () => _studentImage(
                                  controller.studentImageUrl.value,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Text(
                                controller.studentNameText.value.isEmpty
                                    ? LocaleKeys.student.tr
                                    : controller.studentNameText.value,
                              ),
                            ),
                            Text(LocaleKeys.student.tr, style: const TextStyle(
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
                              Text(LocaleKeys.studentId.tr, style: AppTextStyle.regularPrimaryBoldblack), const SizedBox(height: 6), Obx(() => _buildInput(controller.studentIdText.value.isEmpty
                                      ? '-'
                                      : controller.studentIdText.value,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(LocaleKeys.classLabel.tr, style: AppTextStyle.regularPrimaryBoldblack), const SizedBox(height: 6), Obx(() => _buildInput(controller.studentGradeText.value.isEmpty
                                      ? '-'
                                      : controller.studentGradeText.value,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(LocaleKeys.shift.tr, style: AppTextStyle.regularPrimaryBoldblack), _buildRadio(controller, LocaleKeys.morning.tr), _buildRadio(controller, LocaleKeys.afternoon.tr), _buildRadio(controller, LocaleKeys.evening.tr),
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.requestLeaveFillInfo.tr,
                      style: AppTextStyle.mediumPrimaryBoldText,
                      softWrap: true,
                    ),
                  ),
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
                              Text('${LocaleKeys.totalLeaveDays.tr}:', style: AppTextStyle.smallPrimaryBoldBlack), 5.width, Container(width: 70,
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
                            Text('${LocaleKeys.leaveFromDate.tr}:', style: AppTextStyle.smallPrimaryBoldBlack), 5.width, Expanded(child: Obx(() => Row(children: [Expanded(child: _dateBox(controller.startDate.value,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: controller.pickStartDate,
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Icon(Icons.date_range, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text('${LocaleKeys.leaveToDate.tr}:', style: AppTextStyle.smallPrimaryBoldBlack), 5.width, Expanded(child: Obx(() => Row(children: [Expanded(child: _dateBox(controller.endDate.value),
                                    ),
                                    GestureDetector(
                                      onTap: controller.pickEndDate,
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Icon(Icons.date_range, size: 20),
                                      ),
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
                            Text('${LocaleKeys.leaveReason.tr}: ', style: AppTextStyle.smallPrimaryBoldBlack), 10.width,
                            _buildLeaveType(
                              controller,
                              label: LocaleKeys.sick.tr,
                              value: 'sick',
                            ),
                            20.width,
                            _buildLeaveType(
                              controller,
                              label: LocaleKeys.busy.tr,
                              value: 'busy',
                            ),
                            20.width,
                            _buildLeaveType(
                              controller,
                              label: LocaleKeys.other.tr,
                              value: 'other',
                            ),
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
                            hintText: LocaleKeys.otherReasonHint.tr,
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
                              final created = await controller.submitRequest();
                              if (created != null) {
                                Get.back(result: created);
                              }
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
    width: double.infinity,
    height: 20,
    alignment: Alignment.center,
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

  Widget _buildLeaveType(
    RequestLeaveController controller, {
    required String label,
    required String value,
  }) => Obx(() {
    final isSelected = controller.leaveType.value == value;
    return GestureDetector(
      onTap: () => controller.leaveType.value = value,
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
          Text(label, style: AppTextStyle.smallPrimaryBoldBlack),
        ],
      ),
    );
  });

  Widget _studentImage(String rawUrl) {
    final candidates = _resolveImageUrlCandidates(rawUrl);
    if (candidates.isEmpty) {
      return const Icon(Icons.person, color: Colors.grey);
    }
    final first = candidates.first;
    if (first.startsWith('assets/')) {
      return Image.asset(first, fit: BoxFit.cover);
    }
    return _studentImageNetwork(candidates, 0);
  }

  Widget _studentImageNetwork(List<String> urls, int index) {
    if (index >= urls.length) {
      return const Icon(Icons.person, color: Colors.grey);
    }
    return CachedNetworkImage(
      imageUrl: urls[index],
      fit: BoxFit.cover,
      width: 90,
      height: 100,
      memCacheWidth: 180,
      memCacheHeight: 200,
      maxWidthDiskCache: 180,
      maxHeightDiskCache: 200,
      httpHeaders: _imageHeaders() ?? const <String, String>{},
      useOldImageOnUrlChange: true,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      placeholder:
          (_, __) => Container(
            color: const Color(0xFFF1F5F9),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Color(0xFF6B7280)),
          ),
      errorWidget: (_, __, ___) => _studentImageNetwork(urls, index + 1),
    );
  }

  Map<String, String>? _imageHeaders() {
    final token = AppConfig.shared.authorizationToken.trim();
    if (token.isEmpty) {
      return null;
    }
    return <String, String>{'Authorization': token, 'Accept': 'image/*'};
  }

  List<String> _resolveImageUrlCandidates(String rawValue) {
    final value = rawValue.trim();
    if (value.isEmpty) {
      return const <String>[];
    }

    final uri = Uri.tryParse(value);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return _networkUrlVariants(value);
    }
    if (value.startsWith('assets/')) {
      return <String>[value];
    }

    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) {
      return const <String>[];
    }
    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    final path = value.replaceAll('\\', '/');
    final raw = path.startsWith('/') ? path.substring(1) : path;
    final candidates = <String>[
      raw,
      if (!raw.startsWith('uploads/')) 'uploads/$raw',
      if (!raw.startsWith('storage/')) 'storage/$raw',
      if (!raw.startsWith('public/')) 'public/$raw',
      raw.replaceFirst('uploads/uploads/', 'uploads/'),
    ];
    final seen = <String>{};
    final resolved = <String>[];
    for (final c in candidates) {
      final url = baseUri.resolve(c).toString();
      if (seen.add(url)) {
        resolved.add(url);
      }
    }
    return resolved;
  }

  List<String> _networkUrlVariants(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return <String>[url];
    }
    final path = uri.path.replaceAll('\\', '/');
    final fixedUploads = path.replaceFirst('/uploads/uploads/', '/uploads/');
    final deduped = _dedupePath(path);
    final variants = <String>[
      uri.replace(path: fixedUploads).toString(),
      uri.replace(path: deduped).toString(),
      url,
    ];
    final seen = <String>{};
    return variants.where((v) => seen.add(v)).toList();
  }

  String _dedupePath(String path) {
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    final compact = <String>[];
    for (final p in parts) {
      if (compact.isEmpty || compact.last.toLowerCase() != p.toLowerCase()) {
        compact.add(p);
      }
    }
    return '/${compact.join('/')}';
  }
}

