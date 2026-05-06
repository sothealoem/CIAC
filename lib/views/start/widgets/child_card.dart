import 'package:flutter/material.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF223039) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF3A4957) : const Color(0xFFDADADA),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: avatar,
        title: Text(
          child.name.isEmpty ? 'Student' : child.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: active ? const _ActiveBadge() : null,
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF3DF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Active',
        style: TextStyle(
          color: Color(0xFF2E7D32),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
