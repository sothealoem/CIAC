import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          final isDetailLoading = controller.isDetailLoading.value;
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
                        ActivityCardWidget(
                          items: activities,
                          onTap: (item) async {
                            final detail = await controller
                                .fetchClassActivityDetail(item.id);
                            if (detail == null) return;
                            Get.to(() => ActivityDetailView(detail: detail));
                          },
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
    );
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
            Text(
              _stripHtml(detail.description),
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF374151),
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
