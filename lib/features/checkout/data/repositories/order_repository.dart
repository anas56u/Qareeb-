import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qareeb/features/checkout/data/model/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    try {
      // سنحفظ الطلبات في مجموعة رئيسية تسمى 'orders'
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      throw Exception('فشل في إرسال الطلب: $e');
    }
  }
  // دالة لجلب الطلبات السابقة من فايربيس
  Future<List<OrderModel>> getUserOrders() async {
    try {
      // نجلب الطلبات ونرتبها حسب التاريخ (الأحدث أولاً)
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      // نحول البيانات القادمة من فايربيس إلى قائمة من OrderModel
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel(
          id: doc.id,
          items: List<Map<String, dynamic>>.from(data['items'] ?? []),
          totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
          orderDate: (data['orderDate'] as Timestamp).toDate(),
          status: data['status'] ?? 'pending',
          paymentMethod: data['paymentMethod'] ?? 'cash',
          pickupTime: data['pickupTime'] ?? 'now',
        );
      }).toList();
    } catch (e) {
      throw Exception('فشل في جلب الطلبات: $e');
    }
  }
}