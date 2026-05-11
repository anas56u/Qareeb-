import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/checkout/presentation/screens/checkout_screen.dart';
import '../../logic/cart_cubit/cart_cubit.dart';
import '../../logic/cart_cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0), // لون خلفية التطبيق الدافئ
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('سلة المشتريات 🛒', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // BlocBuilder هنا يستمع للـ CartCubit ليعيد رسم الشاشة عند أي تغيير في الكمية أو السعر
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          // حالة السلة الفارغة
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('سلتك فارغة حالياً!', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('اكتشف فروعنا وأضف قهوتك المفضلة', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                ],
              ),
            );
          }

          // حالة وجود طلبات
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 1. صورة المشروب
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.product.imageUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // 2. تفاصيل المشروب والتخصيص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                // عرض التخصيصات (الحجم، الحليب، السكر) بشكل نصي
                                Text(
                                  '${item.selectedSize?['name'] ?? ''} ${item.selectedMilk != null ? '، ${item.selectedMilk}' : ''} ${item.selectedSugar != null ? '، ${item.selectedSugar}' : ''}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${item.unitPrice} د.ا',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
                                ),
                              ],
                            ),
                          ),
                          
                          // 3. أزرار التحكم بالكمية (+ و -)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.brown[50],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18, color: Colors.brown),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(item.id, false);
                                  },
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18, color: Colors.brown),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(item.id, true);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 4. قسم الإجمالي والدفع (Bottom Bar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('الإجمالي المطلوب:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${state.totalAmount.toStringAsFixed(2)} د.ا', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // سنقوم بربط هذا الزر بشاشة الدفع (Checkout) لاحقاً
                           Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CheckoutScreen(totalAmount: state.totalAmount),
    ),
  );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('إتمام الطلب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}