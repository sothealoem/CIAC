import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/views.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.notification.tr)),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const DarkGreyDivider(indent: 25);
        },
        padding: EdgeInsets.only(
          left: UIConstants.spacing.toDouble(),
          right: UIConstants.spacing.toDouble(),
          top: UIConstants.spacing.toDouble(),
          bottom: UIConstants.midSpacing.toDouble(),
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: UIConstants.midSpacing.padBottom,
            child: const NotificationItemWidget(),
          );
        },
      ),
    );
  }
}
