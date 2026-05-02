  import '../../data/models/user_model.dart';

// نستخدم abstract class ليكون بمثابة المظلة الأساسية لكل الحالات
abstract class AuthState {}

// 1. الحالة الابتدائية (عند فتح الشاشة)
class AuthInitial extends AuthState {}

// 2. حالة التحميل (عندما ننتظر رد الفايربيس)
class AuthLoading extends AuthState {}

// 3. حالة النجاح (تحمل معها بيانات المستخدم لاستخدامها لاحقاً)
class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess({required this.user});
}

// 4. حالة الفشل (تحمل معها رسالة الخطأ لعرضها للمستخدم)
class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}