import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/child_profile/child_profile.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({
    super.key,
    required this.child,
    required this.active,
    required this.avatar,
    this.onTap,
  });

  final ChildProfile child;
  final bool active;
  final Widget avatar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        active
            ? const Color(0xFFD50B1E)
            : isDark
            ? const Color(0xFF3A4957)
            : const Color(0xFFE5E7EB);
    final backgroundColor =
        active
            ? const Color(0xFFFFF1F2)
            : isDark
            ? const Color(0xFF223039)
            : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: active ? 1.4 : 1),
        boxShadow:
            active
                ? [
                  BoxShadow(
                    color: const Color(0xFFD50B1E).withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                SizedBox(width: 46, height: 46, child: avatar),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        child.name.isEmpty ? LocaleKeys.student.tr : child.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color:
                              active
                                  ? const Color(0xFF8B0000)
                                  : Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        active
                            ? LocaleKeys.selectedChild.tr
                            : LocaleKeys.tapToSwitchChild.tr,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color:
                              active
                                  ? const Color(0xFFD50B1E)
                                  : const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (active) const _ActiveBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFD50B1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
    );
  }
}
