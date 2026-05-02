import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart'; //
import '../widgets/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // الخلفية الموحدة (الصورة والتدرج)
          SizedBox.expand(
            child: Stack(
              children: [
                Image.asset(AppImages.auth_picture, fit: BoxFit.cover, width: double.infinity, height: double.infinity), //
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.9), Colors.black.withOpacity(0.3)],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SignUpBody(),
        ],
      ),
    );
  }
}