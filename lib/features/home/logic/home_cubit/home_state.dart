import '../../data/models/cafe_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CafeModel> cafes;
  HomeSuccess({required this.cafes});
}

class HomeFailure extends HomeState {
  final String errorMessage;
  HomeFailure({required this.errorMessage});
}