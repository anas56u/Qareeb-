import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/orders/logic/order_cubit/order_state.dart';
import '../../../checkout/data/repositories/order_repository.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository repository;

  OrdersCubit(this.repository) : super(OrdersInitial());

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      final orders = await repository.getUserOrders();
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersError(message: e.toString()));
    }
  }
}