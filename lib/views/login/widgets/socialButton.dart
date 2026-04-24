import 'package:flutter/material.dart';
import 'package:ciac_school/core/constants/asset_path.dart';

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

class SocialButton extends StatelessWidget {
  final String buttonText;
  final String imagePath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.buttonText,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 30,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 30, height: 30, fit: BoxFit.fill),

            Text(
              buttonText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButtonsWidget extends StatelessWidget {
  const SocialButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              buttonText: '',
              imagePath: AssetPath.fb.path, // Replace with your image path
              onPressed: handleFacebookLogin,
            ),
            SizedBox(
              width: 10,
            ), // Adjust horizontal spacing between buttons if needed
            SocialButton(
              buttonText: '',
              imagePath: AssetPath.youtube.path, // Replace with your image path
              onPressed: handleGoogleLogin,
            ),
            SizedBox(
              width: 12,
            ), // Adjust horizontal spacing between buttons if needed
            SocialButton(
              buttonText: '',
              imagePath: AssetPath.twitter.path, // Replace with your image path
              onPressed: handleTwitterLogin,
            ),
          ],
        ),
      ],
    );
  }
}
