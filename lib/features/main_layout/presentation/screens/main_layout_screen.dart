import 'package:flutter/material.dart';
// استيراد الشاشات التي ستكون داخل التبويبات
import '../../../home/presentation/screens/home_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  // متغير لتخزين رقم التبويب الحالي (يبدأ من 0 وهو الشاشة الرئيسية)
  int _currentIndex = 0;

  // قائمة الشاشات التي سيتم التنقل بينها
  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrdersScreen(),
    // يمكنك لاحقاً إضافة شاشة رابعة للملف الشخصي ProfileScreen
    const Center(child: Text('الملف الشخصي - قريباً', style: TextStyle(fontSize: 18))), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // استخدام IndexedStack للحفاظ على حالة الشاشات وعدم إعادة بنائها
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // تصميم شريط التنقل السفلي الاحترافي
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index; // تغيير التبويب عند الضغط
              });
            },
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed, // مهم إذا كان لديك أكثر من 3 تبويبات
            selectedItemColor: Colors.brown, // لون التبويب النشط
            unselectedItemColor: Colors.grey[400], // لون التبويبات غير النشطة
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.home_rounded),
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.shopping_bag_rounded),
                ),
                label: 'السلة',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.receipt_long_rounded),
                ),
                label: 'طلباتي',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.person_rounded),
                ),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}