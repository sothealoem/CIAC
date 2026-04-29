import 'package:flutter/material.dart';
import 'package:schoolapp/core/core.dart';

class RoleSwitchLabel extends StatelessWidget {
  const RoleSwitchLabel({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: isSelected ? AppColor.primary.withOpacity(0.12) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.primary : Colors.black54,
          ),
        ),
      ),
    );
  }
}
