import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // 💡 Best Practice: Dependency Injection
  // نمرر الـ Repository عبر الـ Constructor لكي لا يعتمد الـ Cubit على نسخة ثابتة
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  // ==========================================
  // 1. دالة تسجيل الدخول
  // ==========================================
  Future<void> signIn({required String email, required String password}) async {
    // فور استدعاء الدالة، نصدر حالة "التحميل" ليقوم الـ UI بإظهار دائرة التحميل
    emit(AuthLoading());
    
    try {
      // نطلب من الـ Repository تنفيذ العملية
      final user = await _authRepository.signIn(email: email, password: password);
      
      // إذا تمت بنجاح، نصدر حالة "النجاح" ونمرر بيانات المستخدم
      emit(AuthSuccess(user: user));
    } catch (e) {
      // إذا فشلت العملية لأي سبب (خطأ في الباسوورد، لا يوجد إنترنت)، نصدر حالة "الفشل"
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  // ==========================================
  // 2. دالة إنشاء الحساب
  // ==========================================
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    
    try {
      final user = await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
      
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  // ==========================================
  // 3. دالة تسجيل الخروج
  // ==========================================
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      // بعد تسجيل الخروج نعود للحالة الابتدائية لكي تظهر شاشة تسجيل الدخول مجدداً
      emit(AuthInitial()); 
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}