import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
import 'package:schoolapp/views/views.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final notifications = [
      (
        title: 'សិស្សម្នាក់បានចូលរួមក្នុងវគ្គសិក្សាថ្មីៗ',
        image: 'assets/images/activity.png',
      ),
      (
        title: 'សូមជូនដំណឹង សកម្មភាពរបស់កូនអ្នកត្រូវបានកត់ត្រា',
        image: 'assets/images/teacher.jpg',
      ),
      (
        title: 'សិស្សរបស់អ្នកបានបញ្ចប់កិច្ចការថ្នាក់រៀន',
        image: 'assets/images/playground.jpg',
      ),
      (
        title: 'សូមអរគុណ ការចូលរួមរបស់អ្នកជួយជំរុញការសិក្សាបានល្អ',
        image: 'assets/images/user_kid.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.notification.tr)),

      body: SafeArea(
        child: DefaultTextStyle.merge(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  LocaleKeys.contactUs.tr,
                  // style: const TextStyle(color: Color(0xFF1F2937), fontSize: 13),
                ),
              ),
              12.height,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomIndicator(progress: 1 / 4),
              ),
              12.height,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshNotifications,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: UIConstants.spacing.toDouble(),
                      right: UIConstants.spacing.toDouble(),
                      top: 2,
                      bottom: UIConstants.midSpacing.toDouble(),
                    ),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/images/playground.jpg',
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...notifications.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: NotificationItemWidget(
                            title: item.title,
                            imagePath: item.image,
                            dateText: '9/27/2024',
                            timeText: '9:13 AM',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
