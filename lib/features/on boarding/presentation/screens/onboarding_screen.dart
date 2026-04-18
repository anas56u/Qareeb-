import 'package:flutter/material.dart';
import 'package:qareeb/features/on%20boarding/presentation/screens/onboarding_screen_2.dart';
import '../../../../core/constants/app_images.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء احتياطية
      body: Stack(
        children: [
          // 1. الطبقة الأولى (الخلفية): صورة القهوة
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              AppImages.onboardingCoffee,
              fit: BoxFit.cover, // لتغطية الشاشة بالكامل
            ),
          ),

          // 2. الطبقة الثانية: تدرج لوني (Gradient Overlay) لضمان وضوح النص
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1), // شفافية خفيفة في الأعلى
                  Colors.black.withOpacity(0.8), // لون داكن في الأسفل خلف النصوص
                ],
              ),
            ),
          ),

     // 3. الطبقة الثالثة: المحتوى (النصوص والأزرار)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                // تغيير المحاذاة الأفقية لتصبح في المنتصف
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  // زر التخطي (Skip) في أعلى اليمين
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // الفراغ الأول: يدفع ما تحته (النصوص) إلى الأسفل
                  const Spacer(), 

                  // العنوان الرئيسي
                  const Text(
                    'Your Neighborhood\nCafe, Just Steps Away.',
                    textAlign: TextAlign.center, // توسيط النص داخلياً
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // النص الفرعي (الوصف)
                  const Text(
                    'Support your local community. Order your favorite coffee from nearby cafes with zero delivery hassle. Just order, walk, and sip!',
                    textAlign: TextAlign.center, // توسيط النص داخلياً
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  // الفراغ الثاني: يوازن الفراغ الأول، فيستقر النص في المنتصف 
                  // ويدفع زر (Next) إلى أسفل الشاشة
                  const Spacer(), 

                  // زر التالي (Next)
                  SizedBox(
                    width: double.infinity, 
                    height: 56, 
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const OnboardingScreen2()), // استبدل Scaffold بشاشة الدخول لاحقاً
                      );},
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}