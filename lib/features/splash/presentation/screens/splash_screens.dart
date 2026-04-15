import 'package:flutter/material.dart';
import 'dart:async';

import 'package:qareeb/core/constants/app_images.dart';
import 'package:qareeb/features/splash/presentation/screens/onboarding_screen.dart'; // نحتاجها لاستخدام Future.delayed

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

  // دالة مسؤولة عن الانتقال بعد مرور وقت محدد
  void _navigateToNextScreen() async {
    // ننتظر لمدة 3 ثوانٍ
    await Future.delayed(const Duration(seconds: 5));
    
    // التأكد من أن الـ Widget ما زالت موجودة في الشجرة قبل الانتقال
    // هذه من أفضل الممارسات لتجنب خطأ (Build context across async gaps)
    if (!mounted) return;

    // هنا ننتقل إلى الشاشة التالية (مؤقتاً سنضع شاشة فارغة، وسنعدلها لاحقاً)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()), // استبدل Scaffold بشاشة الدخول لاحقاً
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. الطبقة الأولى (الخلفية): صورة التطبيق
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              AppImages.splash,
              fit: BoxFit.cover,
            ),
          ),
          
          // 2. الطبقة الثانية (فوق الصورة): مؤشر التحميل
          // استخدمنا Align لكي نتحكم بمكان المؤشر بدقة (هنا وضعناه في الأسفل بالوسط)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              // أضفنا مسافة من الأسفل لكي لا يكون المؤشر ملتصقاً بحافة الشاشة
              padding: const EdgeInsets.only(bottom: 80.0), 
              // مؤشر التحميل
              child: const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFD4AF37), // لون ذهبي متناسق مع شعار تطبيق "قريب"
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}