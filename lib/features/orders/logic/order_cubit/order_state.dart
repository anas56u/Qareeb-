
import 'package:qareeb/features/checkout/data/model/order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}
class OrdersLoading extends OrdersState {}
class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}
class OrdersError extends OrdersState {
  final String message;
  OrdersError({required this.message});
}