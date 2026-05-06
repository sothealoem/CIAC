import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/views.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide = constraints.biggest.shortestSide;
            final logoSize =
                (shortestSide * 0.34).clamp(120.0, 170.0).toDouble();
            final titleSize =
                (shortestSide * 0.072).clamp(24.0, 34.0).toDouble();
            final subtitleSize =
                (shortestSide * 0.038).clamp(12.0, 16.0).toDouble();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Hero(
                      tag: 'app_logo_hero',
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ),
                ),
                20.height,
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'welcomeTo'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF084E49),
                      height: 1.05,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'createAccountAndAccessCoolStuffs'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: const Color(0xFF1E1E1E),
                      height: 1,
                    ),
                  ),
                ),

                const Spacer(flex: 3),
              ],
            );
          },
        ),
      ),
    );
  }
}
