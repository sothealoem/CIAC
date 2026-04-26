import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                (shortestSide * 0.095).clamp(30.0, 46.0).toDouble();
            final subtitleSize =
                (shortestSide * 0.050).clamp(16.0, 20.0).toDouble();

            return Column(
              children: [
                const Spacer(flex: 2),
                Hero(
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
                const SizedBox(height: 28),
                Text(
                  'Welcome To',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF084E49),
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Create an account and access thousand of cool stuffs.',
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
