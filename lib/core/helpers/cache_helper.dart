import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  // دالة التهيئة: نستدعيها مرة واحدة عند تشغيل التطبيق
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // دالة عامة لحفظ أي نوع من البيانات (نحن سنستخدمها لحفظ قيمة boolean)
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  // دالة لجلب البيانات
  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  // دالة لمسح قيمة معينة (مفيدة عند تسجيل الخروج إذا أردنا مسح بيانات معينة)
  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}