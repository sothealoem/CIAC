import 'package:flutter/material.dart';
import 'package:schoolapp/core/constants/asset_path.dart';

void handleFacebookLogin() {}

void handleGoogleLogin() {}

void handleTwitterLogin() {}

class SocialButtonCustom extends StatelessWidget {
  final String buttonText;
  final String imagePath;
  final VoidCallback onPressed;

  const SocialButtonCustom({
    super.key,
    required this.buttonText,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 30,
        width: 30,
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          //borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
        ),

        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class SocialButtonCustomWidget extends StatelessWidget {
  const SocialButtonCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButtonCustom(
              buttonText: '',
              imagePath: AssetPath.fb.path,
              onPressed: handleFacebookLogin,
            ),
            const SizedBox(width: 6),
            SocialButtonCustom(
              buttonText: '',
              imagePath: AssetPath.twitter.path,
              onPressed: handleGoogleLogin,
            ),
            const SizedBox(width: 6),
            SocialButtonCustom(
              buttonText: '',
              imagePath: AssetPath.linked.path,
              onPressed: handleTwitterLogin,
            ),
          ],
        ),
      ],
    );
  }
}
