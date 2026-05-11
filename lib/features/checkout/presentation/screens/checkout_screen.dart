import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/checkout/data/model/order_model.dart';
import 'package:qareeb/features/checkout/data/repositories/order_repository.dart';
import 'package:qareeb/features/checkout/presentation/screens/order_success_screen.dart';
import '../../../cart/logic/cart_cubit/cart_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  const CheckoutScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'cash'; // القيمة الافتراضية
  String _selectedPickupTime = 'now'; // القيمة الافتراضية
  bool _isLoading = false; // لإدارة حالة التحميل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('تأكيد الطلب', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. قسم وقت الاستلام
                  const Text('متى ستستلم طلبك؟', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTimeOption('now', 'في أقرب وقت\n(10-15 دقيقة)', Icons.timer)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTimeOption('later', 'تحديد وقت\n(لاحقاً)', Icons.schedule)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 2. قسم طريقة الدفع
                  const Text('طريقة الدفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('الدفع عند الاستلام (كاش)'),
                          secondary: const Icon(Icons.money, color: Colors.green),
                          value: 'cash',
                          groupValue: _selectedPaymentMethod,
                          activeColor: Colors.brown,
                          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          title: const Text('بطاقة ائتمانية (Visa/Mastercard)'),
                          secondary: const Icon(Icons.credit_card, color: Colors.blue),
                          value: 'card',
                          groupValue: _selectedPaymentMethod,
                          activeColor: Colors.brown,
                          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. ملخص الفاتورة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('المجموع الفرعي', '${widget.totalAmount.toStringAsFixed(2)} د.ا'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('رسوم الخدمة', '0.00 د.ا'), // مجاني لأن الاستلام من الفرع
                        const Divider(height: 24),
                        _buildSummaryRow('الإجمالي', '${widget.totalAmount.toStringAsFixed(2)} د.ا', isTotal: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. زر التأكيد السفلي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                 onPressed: _isLoading ? null : () async {
  setState(() => _isLoading = true); // ابدأ التحميل

  try {
    // 1. جلب عناصر السلة من الـ Cubit
    final cartState = context.read<CartCubit>().state;
    
    // 2. تحويل عناصر السلة لشكل Map ليتم حفظها في Firebase
    final orderItems = cartState.items.map((item) => {
      'name': item.product.name,
      'quantity': item.quantity,
      'price': item.unitPrice,
      'customizations': {
        'size': item.selectedSize?['name'],
        'milk': item.selectedMilk,
        'sugar': item.selectedSugar,
      }
    }).toList();

    // 3. إنشاء كائن الطلب
    final newOrder = OrderModel(
      id: '', // Firestore سيقوم بتوليد ID تلقائي
      items: orderItems,
      totalAmount: widget.totalAmount,
      orderDate: DateTime.now(),
      status: 'pending',
      paymentMethod: _selectedPaymentMethod,
      pickupTime: _selectedPickupTime,
    );

    // 4. إرسال الطلب لـ Firebase
    await OrderRepository().placeOrder(newOrder);

    // 5. مسح السلة
    context.read<CartCubit>().clearCart();

    // 6. التوجيه لشاشة النجاح
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
      (route) => false,
    );
  } catch (e) {
    setState(() => _isLoading = false); // أوقف التحميل عند الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('حدث خطأ: ${e.toString()}'), backgroundColor: Colors.red),
    );
  }
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
child: _isLoading 
    ? const CircularProgressIndicator(color: Colors.white) 
    : const Text('تأكيد الطلب 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة لترتيب الكود (Clean Code)
  Widget _buildTimeOption(String value, String title, IconData icon) {
    final isSelected = _selectedPickupTime == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPickupTime = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.brown : Colors.grey.shade300),
          boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.brown, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.brown : Colors.black87,
          ),
        ),
      ],
    );
  }
}