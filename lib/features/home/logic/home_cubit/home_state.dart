import '../../data/models/cafe_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {} // الحالة الافتراضية

class HomeLoading extends HomeState {} // حالة التحميل (لعرض دائرة التحميل)

class HomeLoaded extends HomeState {
  final List<CafeModel> cafes;
  HomeLoaded({required this.cafes}); // حالة النجاح (تحمل البيانات معها)
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message}); // حالة الفشل (تحمل رسالة الخطأ)
}