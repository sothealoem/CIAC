import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/event_gallery/controller.dart';
import 'package:schoolapp/views/start/widgets/custom_appbar.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';

class EventGalleryView extends GetView<EventGalleryController> {
  const EventGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_GalleryItem>[
      const _GalleryItem(
        imagePath: 'assets/images/photo_2024-07-16_16-55-33.jpg',
        title: 'សិស្សានុសិស្សចូលរួមសកម្មភាពសិក្សាប្រចាំថ្ងៃជាមួយក្រុមគ្រូ។',
        date: '9/27/2024',
        time: '10:13 AM',
      ),
      const _GalleryItem(
        imagePath: 'assets/images/studentprofile.jpg',
        title:
            'សកម្មភាពក្នុងថ្នាក់បង្កើនចំណង់ចំណូលចិត្ត និងការយល់ដឹងកាន់តែខ្ពស់។',
        date: '9/27/2024',
        time: '9:43 AM',
      ),
      const _GalleryItem(
        imagePath: 'assets/images/playground.jpg',
        title: 'សិស្សរៀនតាមរយៈការសហការជាក្រុម និងការចែករំលែកយោបល់។',
        date: '9/27/2024',
        time: '11:23 AM',
      ),
      const _GalleryItem(
        imagePath: 'assets/images/activity.png',
        title: 'សកម្មភាពក្នុងបរិយាកាសថ្នាក់ជំរុញភាពច្នៃប្រឌិតរបស់សិស្ស។',
        date: '9/27/2024',
        time: '1:19 PM',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomizeAppBar(
                title: 'កំណត់ត្រាវត្តមាន',
                subTitle:
                    'លោកអ្នកអាចដឹងពីវត្តមាន កូនៗរបស់លោកអ្នកពេលកំពុងសិក្សា',
              ),
              UIConstants.spacingSmall.height,

              const CustomIndicator(progress: 1 / 4),
              SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/activity.png',
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              20.height,
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 214,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _EventCard(item: item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.item});

  final _GalleryItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.asset(
            item.imagePath,
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 14,
            height: 1.22,
            color: Color(0xFF212121),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${item.date}   ${item.time}',
          style: TextStyle(
            fontFamily: 'Battambang',
            fontSize: 12.5,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GalleryItem {
  const _GalleryItem({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.time,
  });

  final String imagePath;
  final String title;
  final String date;
  final String time;
}
