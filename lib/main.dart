import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// استدعاء ملفاتك الصحيحة هنا
import 'core/helpers/cache_helper.dart'; 
import 'features/on boarding/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  // 💡 ضروري جداً: هذا السطر يضمن أن الفلاتر قام بتجهيز بيئة العمل قبل تنفيذ أي كود Async
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الفايربيس
  await Firebase.initializeApp();
  
  // تهيئة SharedPreferences
  await CacheHelper.init();

  Widget widget; // المتغير الذي سيحمل الشاشة الأولى

  // 1. التحقق من الـ Onboarding
  bool? isOnboardingSeen = CacheHelper.getData(key: 'onBoarding');

  if (isOnboardingSeen != null) {
    // إذا رأى المستخدم الـ Onboarding، ننتقل للتحقق من الفايربيس
    // 2. التحقق من حالة المستخدم في Firebase Auth
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // مسجل دخول مسبقاً -> يذهب للرئيسية فوراً
      widget = const HomeScreen(); 
    } else {
      // غير مسجل دخول -> يذهب لشاشة تسجيل الدخول
      widget = const LoginScreen(); 
    }
  } else {
    // إذا لم تكن القيمة محفوظة، فهذه أول مرة يفتح فيها التطبيق
    widget = const OnBoardingScreen(); 
  }

  // تشغيل التطبيق وتمرير الشاشة المحددة
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qareeb',
      home: startWidget, // تعيين الشاشة المحددة كشاشة رئيسية
    );
  }
}