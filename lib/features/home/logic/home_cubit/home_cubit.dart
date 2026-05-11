import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../../data/repositories/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  // عند إنشاء الـ Cubit، نمرر له الـ Repository ونبدأ بالحالة Initial
  HomeCubit(this.repository) : super(HomeInitial());

  // دالة لجلب البيانات
  Future<void> fetchHomeData() async {
    emit(HomeLoading()); // 1. نخبر الواجهة أننا بدأنا التحميل

    try {
      final cafes = await repository.getNearbyCafes(); // 2. نطلب البيانات
      emit(HomeLoaded(cafes: cafes)); // 3. نجحنا! نرسل البيانات للواجهة
    } catch (e) {
      emit(HomeError(message: e.toString())); // 4. فشلنا! نرسل رسالة الخطأ
    }
  }
}