import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/checkout/data/repositories/order_repository.dart';
import 'package:qareeb/features/orders/logic/order_cubit/order_cubit.dart';
import 'package:qareeb/features/orders/logic/order_cubit/order_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  // دالة مساعدة لتحديد لون ونص الحالة
  Map<String, dynamic> _getStatusDetails(String status) {
    switch (status) {
      case 'pending': return {'text': 'قيد الانتظار ⏳', 'color': Colors.orange};
      case 'preparing': return {'text': 'جاري التحضير ☕', 'color': Colors.blue};
      case 'ready': return {'text': 'جاهز للاستلام ✅', 'color': Colors.green};
      case 'completed': return {'text': 'مكتمل 🎉', 'color': Colors.grey};
      default: return {'text': 'غير معروف', 'color': Colors.black};
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(OrderRepository())..fetchOrders(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F4F0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text('طلباتي السابقة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.brown));
            } else if (state is OrdersError) {
              return Center(child: Text(state.message));
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('لا يوجد لديك طلبات سابقة حتى الآن.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  final statusDetails = _getStatusDetails(order.status);
                  
                  // تنسيق التاريخ ليظهر بشكل جميل (مثال: 12 مايو 2026 - 10:30 ص)
                  // يمكنك استخدام حزمة intl أو عرضها كنص بسيط
                  String formattedDate = '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('رقم الطلب: ${order.id.substring(0, 6)}...', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text(formattedDate, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 24),
                        
                        // عرض المشروبات في الطلب
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item['quantity']}x ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${item['price']} د.ا', style: const TextStyle(color: Colors.brown)),
                            ],
                          ),
                        )).toList(),
                        
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('الإجمالي', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text('${order.totalAmount} د.ا', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
                              ],
                            ),
                            
                            // شارة حالة الطلب
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: (statusDetails['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusDetails['text'],
                                style: TextStyle(color: statusDetails['color'], fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}