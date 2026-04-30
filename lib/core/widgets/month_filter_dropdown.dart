import 'package:flutter/material.dart';

class MonthFilterDropdown extends StatelessWidget {
  final List<String> months;
  final String selectedMonth;
  final ValueChanged<String> onSelected;
  final TextStyle? textStyle;
  final Color borderColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool showFilterIcon;
  final Color iconColor;
  final double menuMaxHeightFactor;
  final double? height;

  const MonthFilterDropdown({
    super.key,
    required this.months,
    required this.selectedMonth,
    required this.onSelected,
    this.textStyle,
    this.borderColor = const Color(0xFF00675B),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.showFilterIcon = true,
    this.iconColor = const Color(0xFF00675B),
    this.menuMaxHeightFactor = 0.45,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final selected =
        months.contains(selectedMonth) && selectedMonth.isNotEmpty
            ? selectedMonth
            : (months.isNotEmpty ? months.first : '');

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: borderRadius,
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        initialValue: selected.isEmpty ? null : selected,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * menuMaxHeightFactor,
        ),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return months.map((String month) {
            return PopupMenuItem<String>(
              value: month,
              child: Text(month, style: textStyle ?? const TextStyle(fontSize: 14)),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                selected,
                overflow: TextOverflow.ellipsis,
                style:
                    textStyle ??
                    const TextStyle(
                      color: Color(0xFF00675B),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
              ),
            ),
            if (showFilterIcon) ...[
              const SizedBox(width: 6),
              Icon(Icons.filter_alt_outlined, color: iconColor, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
