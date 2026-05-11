import 'package:flutter/material.dart';
import 'package:qareeb/core/helpers/cache_helper.dart';
import 'package:qareeb/features/auth/presentation/screens/login_screen.dart';
import 'package:qareeb/features/main_layout/presentation/screens/main_layout_screen.dart';
import '../../../../core/constants/app_images.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء احتياطية
      body: Stack(
        children: [
          // 1. الطبقة الأولى (الخلفية): صورة اللاتيه الجديدة
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              AppImages.onboardingLatte,
              fit: BoxFit.cover,
            ),
          ),

          // 2. الطبقة الثانية: تدرج لوني (Gradient Overlay) لضمان وضوح النص
          // نستخدم نفس التدرج من الشاشة السابقة لضمان الاتساق
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

          // 3. الطبقة الثالثة: المحتوى (النصوص والأزرار) - SafeArea
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                // توسيط أفقي لكل المحتوى
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  // زر التخطي (Skip) في أعلى اليمين
                 Align(
  alignment: Alignment.topRight,
  child: TextButton(
    onPressed: () async {
      // حفظ أن المستخدم شاهد الـ Onboarding حتى لا تظهر له مرة أخرى
      await CacheHelper.saveData(key: 'onBoarding', value: true);
      
      if (context.mounted) {
        // نتوجه مباشرة إلى الشاشة الرئيسية (الحاوية الجديدة)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
        );
      }
    },
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
                  // الفراغ الأول لتوسيط النص عمودياً
                  const Spacer(), 

                  // العنوان الرئيسي الجديد
                  const Text(
                    'Brewed for You,\nReady for Pick-Up.',
                    textAlign: TextAlign.center, // توسيط داخلي
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2, // المسافة بين السطور
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // النص الفرعي الجديد (الوصف)
                  const Text(
                    'Skip the lines at your local cafe. Place your order in advance and simply walk in to grab your fresh brew. Perfect for your busy schedule.',
                    textAlign: TextAlign.center, // توسيط داخلي
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  // الفراغ الثاني لتوسيط النص ودفع زر (Next) للأسفل
                  const Spacer(), 

                  // زر التالي (Next) - نفس تصميم الزر السابق
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37), // لون ذهبي
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                   onPressed: () async {
  await CacheHelper.saveData(key: 'onBoarding', value: true);
  
  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      // إذا كان التطبيق يتطلب تسجيل دخول، اتركها LoginScreen
      // إذا كنت تريد الدخول فوراً للتطبيق، غيرها إلى MainLayoutScreen
      MaterialPageRoute(builder: (context) => const LoginScreen()), 
    );
  }
},
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.black, // نص أسود لتباين أفضل مع الذهبي
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