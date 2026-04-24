import 'package:flutter/material.dart';
import 'package:ciac_school/core/core.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetPath.appLogo.path,
      height: 150,
      width: 150,
      fit: BoxFit.contain,
    );
  }
}
