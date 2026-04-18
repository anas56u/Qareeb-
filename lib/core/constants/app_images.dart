class AppImages {
  // نجعل الـ Constructor خاصاً لمنع إنشاء كائنات (Instances) من هذا الكلاس
  AppImages._();

  // المسار الأساسي لمجلد الصور
  static const String _imagePath = 'assets/images';

  // تعريف مسارات الصور كمتغيرات ثابتة
  static const String splash = '$_imagePath/splash1.png';
  static const String onboardingCoffee = '$_imagePath/Onboarding1.png';

static const String onboardingLatte = '$_imagePath/Onboarding2.png';

static const String auth_picture='$_imagePath/authPic.png';
static const String logo = '$_imagePath/logo.png';



  
  // غداً عندما تضيف صوراً أخرى، ستضعها هنا:
  // static const String logo = '$_imagePath/logo.png';
}