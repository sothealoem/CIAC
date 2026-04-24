import 'package:flutter/material.dart';
import 'package:ciac_school/core/core.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(text ?? 'No Data', style: AppTextStyle.mediumPrimaryBold),
    );
  }
}
