import 'package:ciac_school/core/configs/app_style.dart';
import 'package:flutter/material.dart';
// import 'package:your_project/core/constants/app_color.dart';
// import 'package:your_project/core/utils/app_text_style.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final IconData? icon; // Added for extra visual polish

  const SummaryItem({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(
            8.0,
          ), // Increased for a softer look
        ),
        child: Column(
          children: [
            // Icon + Label Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: AppTextStyle.mendiumPrimaryBold.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // The Count
            Text(
              count,
              style: TextStyle(
                fontFamily: 'battambang', // Keeping your specific font
                color: color,
                fontSize: 18, // Slightly larger to stand out
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            // The Accent Bottom Bar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              child: Container(
                height: 4,
                width: double.infinity,
                color: color, // Matching the accent bar to the text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
