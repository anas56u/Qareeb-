import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/auth/data/repositories/auth_repository.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:qareeb/features/splash/presentation/screens/splash_screens.dart';
import 'package:qareeb/firebase_options.dart';
// استدعاء مسار شاشة البداية التي قمنا بإنشائها

main() async {
  // هذه الدالة تضمن تهيئة محرك Flutter بالكامل قبل تشغيل التطبيق
  // نحتاجها دائماً إذا كنا سنضيف أوامر غير متزامنة (مثل تهيئة Firebase لاحقاً)
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // أمر تشغيل التطبيق، ونمرر له الـ Widget الأساسي
  runApp(const QareebApp());
}

// يفضل دائماً فصل التطبيق في كلاس مستقل من نوع StatelessWidget
class QareebApp extends StatelessWidget {
  const QareebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        // 💡 Best Practice: Dependency Injection
        // نمرر الـ Repository مباشرة عند إنشاء الـ Cubit. هذا يجعل الكود أكثر مرونة وقابلية للاختبار.
        AuthRepository(),
      ),
      child: MaterialApp(
        title: 'Qareeb - قريب', // اسم التطبيق الذي يظهر في مدير المهام بالجوال
        debugShowCheckedModeBanner:
            false, // إخفاء شريط الـ Debug الأحمر المزعج من الزاوية
        // إعدادات المظهر العام للتطبيق (Theme)
        theme: ThemeData(
          // استخدام Material 3 وهو الإصدار الأحدث من تصميمات جوجل
          useMaterial3: true,
          // تحديد لون أساسي مبدئي للتطبيق (سنقوم بتخصيص الألوان لاحقاً في مجلد الـ core)
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        ),

        // السطر الأهم حالياً: تحديد الشاشة الافتراضية الأولى
        home: const SplashScreen(),
      ),
    );
  }
}
