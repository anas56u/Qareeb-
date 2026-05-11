import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/cart/data/model/cart_item_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  // 1. إضافة عنصر للسلة
  void addToCart(CartItemModel newItem) {
    // نأخذ نسخة من القائمة الحالية لنتمكن من تعديلها
    final currentItems = List<CartItemModel>.from(state.items);

    // التحقق: هل نفس المنتج بنفس التخصيصات موجود مسبقاً؟
    int existingIndex = currentItems.indexWhere((item) =>
        item.product.id == newItem.product.id &&
        item.selectedSize?['name'] == newItem.selectedSize?['name'] &&
        item.selectedMilk == newItem.selectedMilk &&
        item.selectedSugar == newItem.selectedSugar);

    if (existingIndex >= 0) {
      // إذا كان موجوداً، نزيد الكمية فقط
      currentItems[existingIndex].quantity += 1;
    } else {
      // إذا لم يكن موجوداً، نضيفه كعنصر جديد
      currentItems.add(newItem);
    }

    _updateState(currentItems);
  }

  // 2. إزالة عنصر من السلة
  void removeFromCart(String itemId) {
    final currentItems = List<CartItemModel>.from(state.items);
    currentItems.removeWhere((item) => item.id == itemId);
    _updateState(currentItems);
  }

  // 3. تحديث الكمية (زيادة أو نقصان)
  void updateQuantity(String itemId, bool isIncrement) {
    final currentItems = List<CartItemModel>.from(state.items);
    int index = currentItems.indexWhere((item) => item.id == itemId);
    
    if (index >= 0) {
      if (isIncrement) {
        currentItems[index].quantity += 1;
      } else {
        if (currentItems[index].quantity > 1) {
          currentItems[index].quantity -= 1;
        } else {
          // إذا كانت الكمية 1 وضغط نقصان، نحذفه من السلة
          currentItems.removeAt(index);
        }
      }
      _updateState(currentItems);
    }
  }

  // دالة مساعدة لحساب السعر الإجمالي وتحديث الحالة (تجنب تكرار الكود)
  void _updateState(List<CartItemModel> items) {
    double total = 0.0;
    for (var item in items) {
      total += item.totalPrice;
    }
    // نرسل State جديدة للواجهة لتحديثها
    emit(CartState(items: items, totalAmount: total));
  }
  // دالة لتفريغ السلة بعد إتمام الطلب بنجاح
  void clearCart() {
    emit(CartState.initial());
  }
}