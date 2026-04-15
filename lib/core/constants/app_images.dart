class AppImages {
  // نجعل الـ Constructor خاصاً لمنع إنشاء كائنات (Instances) من هذا الكلاس
  AppImages._();

  // المسار الأساسي لمجلد الصور
  static const String _imagePath = 'assets/images';

  // تعريف مسارات الصور كمتغيرات ثابتة
  static const String splash = '$_imagePath/splash1.png';
  static const String onboardingCoffee = '$_imagePath/splash2.png';

static const String onboardingLatte = '$_imagePath/Onboarding2.png';

  
  // غداً عندما تضيف صوراً أخرى، ستضعها هنا:
  // static const String logo = '$_imagePath/logo.png';
}