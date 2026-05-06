import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/views/event_gallery/controller.dart';

class ActivityCardWidget extends StatelessWidget {
  const ActivityCardWidget({super.key, required this.items, this.onTap});

  final List<ClassActivityItem> items;
  final void Function(ClassActivityItem item)? onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 12,
        mainAxisExtent: 170,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: onTap == null ? null : () => onTap!(item),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _cardImage(item.image),
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _desc10(item.description),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        );
      },
    );
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
      errorBuilder:
          (_, __, ___) => Container(
            color: const Color(0xFFE9EEF2),
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
    );
  }

  String _desc10(String raw) {
    final clean = raw.replaceAll(RegExp(r'<[^>]*>'), ' ').trim();
    if (clean.isEmpty) return '';
    final words =
        clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (words.length <= 10) return clean;
    return '${words.take(10).join(' ')}...';
  }
}
