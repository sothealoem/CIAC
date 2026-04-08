import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/configs.dart';

class CustomIndicator extends StatelessWidget {
  final double progress; // value between 0.0 - 1.0

  const CustomIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final dotPosition = barWidth * progress;

        return Container(
          height: 4, // thinner like your image
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Progress line
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
