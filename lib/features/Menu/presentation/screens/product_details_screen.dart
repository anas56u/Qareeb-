import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/menu/data/models/product_model.dart';
import 'package:qareeb/features/cart/data/model/cart_item_model.dart';
import 'package:qareeb/features/cart/logic/cart_cubit/cart_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // متغيرات لتخزين اختيارات المستخدم
  Map<String, dynamic>? _selectedSize;
  String? _selectedMilk;
  String? _selectedSugar;

  // السعر الإجمالي الذي سيتغير بناءً على الحجم
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    // 1. تحديد السعر المبدئي
    _totalPrice = widget.product.price;

    // 2. تعيين القيم الافتراضية (مثلاً: اختيار أول حجم، أول نوع حليب)
    final customizations = widget.product.customizations;
    
    if (customizations.containsKey('sizes') && (customizations['sizes'] as List).isNotEmpty) {
      _selectedSize = customizations['sizes'][0];
      _totalPrice += _selectedSize!['price']; // إضافة سعر الحجم الافتراضي
    }
    
    if (customizations.containsKey('milk') && (customizations['milk'] as List).isNotEmpty) {
      _selectedMilk = customizations['milk'][0];
    }
    
    if (customizations.containsKey('sugar') && (customizations['sugar'] as List).isNotEmpty) {
      _selectedSugar = customizations['sugar'][0];
    }
  }

  // دالة لتحديث السعر عند تغيير الحجم
  void _updatePrice(Map<String, dynamic> newSize) {
    setState(() {
      // نطرح سعر الحجم القديم، ونضيف سعر الحجم الجديد
      _totalPrice = _totalPrice - (_selectedSize?['price'] ?? 0.0) + (newSize['price'] ?? 0.0);
      _selectedSize = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customizations = widget.product.customizations;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0), // نفس لون خلفية التطبيق
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(widget.product.name, style: const TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. صورة المشروب
                  Container(
                    width: double.infinity,
                    height: 250,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: DecorationImage(
                        image: NetworkImage(widget.product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                  ),

                  // 2. الاسم والوصف
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. قسم الأحجام (إن وُجد)
                  if (customizations.containsKey('sizes'))
                    _buildSectionTitle('اختيار الحجم'),
                  if (customizations.containsKey('sizes'))
                    ...((customizations['sizes'] as List).map((size) {
                      return RadioListTile<Map<String, dynamic>>(
                        title: Text(size['name']),
                        subtitle: size['price'] > 0 ? Text('+${size['price']} د.ا', style: const TextStyle(color: Colors.brown)) : null,
                        value: size,
                        groupValue: _selectedSize,
                        activeColor: Colors.brown,
                        onChanged: (value) {
                          if (value != null) _updatePrice(value);
                        },
                      );
                    }).toList()),

                  // 4. قسم الحليب (إن وُجد)
                  if (customizations.containsKey('milk'))
                    _buildSectionTitle('نوع الحليب'),
                  if (customizations.containsKey('milk'))
                    ...((customizations['milk'] as List).map((milk) {
                      return RadioListTile<String>(
                        title: Text(milk.toString()),
                        value: milk.toString(),
                        groupValue: _selectedMilk,
                        activeColor: Colors.brown,
                        onChanged: (value) => setState(() => _selectedMilk = value),
                      );
                    }).toList()),

                  // 5. قسم السكر (إن وُجد)
                  if (customizations.containsKey('sugar'))
                    _buildSectionTitle('مستوى السكر'),
                  if (customizations.containsKey('sugar'))
                    ...((customizations['sugar'] as List).map((sugar) {
                      return RadioListTile<String>(
                        title: Text(sugar.toString()),
                        value: sugar.toString(),
                        groupValue: _selectedSugar,
                        activeColor: Colors.brown,
                        onChanged: (value) => setState(() => _selectedSugar = value),
                      );
                    }).toList()),
                    
                  const SizedBox(height: 40), // مساحة سفلية
                ],
              ),
            ),
          ),

          // 6. شريط الإضافة للسلة السفلي (Bottom Bar)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // عرض السعر الإجمالي
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السعر الإجمالي', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text(
                        '$_totalPrice د.ا',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // زر الإضافة للسلة
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final cartItem = CartItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID عشوائي وفريد للطلب
      product: widget.product,
      selectedSize: _selectedSize,
      selectedMilk: _selectedMilk,
      selectedSugar: _selectedSugar,
      unitPrice: _totalPrice, // السعر الحسوب بناءً على الحجم
      quantity: 1,
    );

    // 2. إرساله إلى الـ CartCubit
    context.read<CartCubit>().addToCart(cartItem);
                        // سنقوم لاحقاً بربط هذا الزر بـ CartCubit لإضافة المشروب للسلة
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم إضافة ${widget.product.name} إلى السلة! ☕'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context); // العودة للمنيو
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('إضافة إلى السلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لرسم عناوين الأقسام
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}