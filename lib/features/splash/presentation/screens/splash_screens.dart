import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:qareeb/core/constants/app_images.dart';
import 'package:qareeb/core/helpers/cache_helper.dart';
import 'package:qareeb/features/on%20boarding/presentation/screens/onboarding_screen.dart';
// ⚠️ تذكر: قم بتعديل اسم المجلد إلى on_boarding في ملفاتك ثم قم بتحديث هذا المسار
import 'package:qareeb/features/auth/presentation/screens/login_screen.dart';
import 'package:qareeb/features/home/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // ننتظر ثانيتين فقط (5 ثوانٍ تعتبر مدة طويلة جداً وتزعج المستخدم)
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    // 1. فحص هل المستخدم شاهد شاشات الترحيب مسبقاً؟
    bool? isOnboardingSeen = CacheHelper.getData(key: 'onBoarding');
    Widget nextScreen;

    if (isOnboardingSeen != null && isOnboardingSeen == true) {
      // 2. التحقق من حالة المستخدم في Firebase Auth
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser != null) {
        nextScreen = const HomeScreen(); // مسجل دخول مسبقاً -> الرئيسية
      } else {
        nextScreen = const LoginScreen(); // غير مسجل دخول -> شاشة تسجيل الدخول
      }
    } else {
      // لم يشاهد الترحيب مسبقاً -> أول مرة يفتح التطبيق
      nextScreen = const OnboardingScreen();
    }

    // الانتقال للشاشة المحددة وإغلاق الـ Splash
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              AppImages.splash,
              fit: BoxFit.cover,
            ),
          ),
          
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0), 
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFD4AF37),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}