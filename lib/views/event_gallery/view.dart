import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/event_gallery/controller.dart';
import 'package:schoolapp/views/event_gallery/widgets/eventgallery_card.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Obx(() {
          final activities = controller.activities.toList(growable: false);
          final isLoading = controller.isLoading.value;
          final isLoadingMore = controller.isLoadingMore.value;
          final isDetailLoading = controller.isDetailLoading.value;
          final hasMorePages = controller.hasMorePages;
          final topImage = activities.isNotEmpty ? activities.first.image : '';

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.fetchClassActivities,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomizeAppBar(
                        title: LocaleKeys.activity.tr,
                        subTitle: LocaleKeys.activitySubTitle.tr,
                        teacherSubTitle: LocaleKeys.activityTeacherSubTitle.tr,
                      ),
                      UIConstants.spacingSmall.height,
                      const CustomIndicator(progress: 1 / 4),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _galleryImage(
                          topImage,
                          height: 170,
                          width: double.infinity,
                        ),
                      ),
                      20.height,
                      if (isLoading && activities.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(
                              color: AppColor.primary,
                            ),
                          ),
                        )
                      else if (activities.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No class activities found',
                              style: TextStyle(),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            ActivityCardWidget(
                              items: activities,
                              onTap: (item) async {
                                final detail = await controller
                                    .fetchClassActivityDetail(item.id);
                                if (detail == null) return;
                                Get.to(() => ActivityDetailView(detail: detail));
                              },
                            ),
                            if (hasMorePages || isLoadingMore) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child:
                                    isLoadingMore
                                        ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: CircularProgressIndicator(
                                              color: AppColor.primary,
                                            ),
                                          ),
                                        )
                                        : OutlinedButton(
                                          onPressed:
                                              controller.loadMoreActivities,
                                          child: Text(
                                            'Load more (${controller.currentPage.value}/${controller.lastPage.value})',
                                          ),
                                        ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (isDetailLoading)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.white),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
      bottomNavigationBar:
          controller.isTeacherRole
              ? SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _openCreateActivity(context),
                      icon: const Icon(Icons.add_photo_alternate_rounded),
                      label: const Text('Create Activity'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  void _openCreateActivity(BuildContext context) {
    Get.to(() => const TeacherCreateActivityView());
  }

  Widget _galleryImage(String imagePath, {double? height, double? width}) {
    if (imagePath.trim().isEmpty) {
      return Container(
        height: height,
        width: width,
        color: const Color(0xFFE9EEF2),
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: Colors.grey),
      );
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: const Color(0xFFE9EEF2)),
        errorWidget:
            (_, __, ___) => Container(
              color: const Color(0xFFE9EEF2),
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
      );
    }

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}

class TeacherCreateActivityView extends StatefulWidget {
  const TeacherCreateActivityView({super.key});

  @override
  State<TeacherCreateActivityView> createState() =>
      _TeacherCreateActivityViewState();
}

class _TeacherCreateActivityViewState extends State<TeacherCreateActivityView> {
  final TextEditingController _titleCtl = TextEditingController();
  final TextEditingController _descriptionCtl = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _titleCtl.dispose();
    _descriptionCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivityController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Create Activity'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a class activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Share a quick classroom update with students and send a push notification after it is posted.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Activity Title',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtl,
              decoration: const InputDecoration(
                hintText: 'For example: Science lab, Reading circle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionCtl,
              minLines: 5,
              maxLines: 7,
              decoration: const InputDecoration(
                hintText:
                    'Write a short summary students should know before opening the full activity.',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Image',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_rounded),
              label: Text(
                _selectedImage == null ? 'Choose Image' : 'Change Image',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedImage == null
                  ? 'Optional. Add one cover image to make the activity card more engaging.'
                  : 'Image selected and ready to upload.',
              style: const TextStyle(
                fontSize: 12,
                height: 1.35,
                color: Color(0xFF6B7280),
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_selectedImage!.path),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isSubmittingActivity.value ? null : _submit,
                  icon:
                      controller.isSubmittingActivity.value
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.send_rounded),
                  label: Text(
                    controller.isSubmittingActivity.value
                        ? 'Submitting...'
                        : 'Create and Notify Students',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (!mounted || image == null) return;
      setState(() => _selectedImage = image);
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
  }

  Future<void> _submit() async {
    final controller = Get.find<ActivityController>();
    final title = _titleCtl.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        LocaleKeys.error.tr,
        'Activity title cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await controller.createActivity(
        title: title,
        description: _descriptionCtl.text.trim(),
        imagePath: _selectedImage?.path ?? '',
      );
      if (!mounted) return;
      Get.back();
      Get.snackbar(
        LocaleKeys.successfully.tr,
        'Activity created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF14925A),
        colorText: Colors.white,
      );
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.item, required this.onTap});

  final ClassActivityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: _cardImage(item.image),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.28,
              color: Color(0xFF212121),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            _formatActivityTime(item.timeText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatActivityTime(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return 'Date not available';

    final dt = DateTime.tryParse(value);
    if (dt != null) {
      return DateFormat('dd/MM/yyyy hh:mm a').format(dt);
    }

    final timeOnly = RegExp(r'^\d{1,2}:\d{2}(:\d{2})?$');
    if (timeOnly.hasMatch(value)) {
      final parsed = DateFormat(
        value.split(':').length == 3 ? 'HH:mm:ss' : 'HH:mm',
      ).parseStrict(value);
      return DateFormat('hh:mm a').format(parsed);
    }

    return value;
  }

  Widget _cardImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: 95,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: const Color(0xFFE9EEF2)),
        errorWidget:
            (_, __, ___) => Container(
              color: const Color(0xFFE9EEF2),
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
      );
    }

    return Image.asset(
      imagePath,
      width: double.infinity,
      height: 95,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}

class ActivityDetailView extends StatelessWidget {
  const ActivityDetailView({super.key, required this.detail});

  final ClassActivityDetailItem detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          LocaleKeys.activity.tr,
          style: const TextStyle(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _detailImage(detail.image),
            ),
            const SizedBox(height: 12),
            Text(
              detail.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                _stripHtml(detail.description).isEmpty
                    ? 'No description was provided for this activity.'
                    : _stripHtml(detail.description),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: const Color(0xFFE9EEF2)),
        errorWidget:
            (_, __, ___) => Container(
              height: 220,
              color: const Color(0xFFE9EEF2),
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
      );
    }

    return Image.asset(
      imagePath,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }

  String _stripHtml(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
