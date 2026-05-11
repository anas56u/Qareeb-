
import 'package:qareeb/features/cart/data/model/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;
  final double totalAmount;

  CartState({required this.items, required this.totalAmount});

  // حالة ابتدائية (سلة فارغة)
  factory CartState.initial() {
    return CartState(items: [], totalAmount: 0.0);
  }
}