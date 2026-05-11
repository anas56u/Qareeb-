import '../../../menu/data/models/product_model.dart';

class CartItemModel {
  final String id; // ID فريد لهذا العنصر في السلة
  final ProductModel product;
  final Map<String, dynamic>? selectedSize;
  final String? selectedMilk;
  final String? selectedSugar;
  final double unitPrice; // سعر الحبة الواحدة بعد إضافة سعر الحجم
  int quantity; // الكمية قابلة للتعديل

  CartItemModel({
    required this.id,
    required this.product,
    this.selectedSize,
    this.selectedMilk,
    this.selectedSugar,
    required this.unitPrice,
    this.quantity = 1,
  });

  // دالة لحساب السعر الإجمالي لهذا العنصر (السعر * الكمية)
  double get totalPrice => unitPrice * quantity;
}