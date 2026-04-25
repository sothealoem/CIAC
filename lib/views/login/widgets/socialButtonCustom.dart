import 'package:flutter/material.dart';
import 'package:schoolapp/core/constants/asset_path.dart';

// Define a function to handle button taps
void handleFacebookLogin() {
  // Handle Facebook login logic here
}

void handleGoogleLogin() {
  // Handle Google login logic here
}

void handleTwitterLogin() {
  // Handle Twitter login logic here
}

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
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
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
            SizedBox(width: 6),
            SocialButtonCustom(
              buttonText: '',
              imagePath: AssetPath.twitter.path,
              onPressed: handleGoogleLogin,
            ),
            SizedBox(
              width: 6,
            ), // Adjust horizontal spacing between buttons if needed
            SocialButtonCustom(
              buttonText: '',
              imagePath: AssetPath.linked.path, // Replace with your image path
              onPressed: handleTwitterLogin,
            ),
          ],
        ),
      ],
    );
  }
}
