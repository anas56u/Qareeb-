import '../../data/models/product_model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<ProductModel> products;
  MenuLoaded({required this.products});
}

class MenuError extends MenuState {
  final String message;
  MenuError({required this.message});
}