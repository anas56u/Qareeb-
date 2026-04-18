import 'package:flutter/material.dart';
import 'package:qareeb/core/constants/app_images.dart';
import 'package:qareeb/core/widgets/primary_button.dart';
import 'package:qareeb/features/auth/presentation/widgets/CustomTextField.dart';
import 'package:qareeb/features/auth/presentation/widgets/SocialButton.dart';
import 'package:qareeb/features/auth/presentation/widgets/login_body.dart';

// افترض أننا أضفنا مسار الصورة هنا
// import '../../../../core/constants/app_images.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // استخدمنا Stack لكي نضع صورة القهوة في طبقة الخلفية السفلية
      body:LoginBody()
    );
  }
}

