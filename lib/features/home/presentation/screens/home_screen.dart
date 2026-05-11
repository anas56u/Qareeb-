import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/cart/presentation/screens/cart_screen.dart';
import 'package:qareeb/features/orders/presentation/screens/orders_screen.dart';
import '../../data/repositories/home_repository.dart';
import '../../logic/home_cubit/home_cubit.dart';
import '../../logic/home_cubit/home_state.dart';
import '../widgets/cafe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeRepository())..fetchHomeData(),
      child: Scaffold(
        // يمكنك تجربة Colors.brown[50] إذا شعرت أن الدرجة 100 غامقة قليلاً
        backgroundColor: Colors.brown[100], 
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. شريط العنوان الترحيبي (AppBar Area)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'صباح الخير، أنس 👋',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.brown[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'حان وقت القهوة!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      // فصلنا الأزرار ليكون كل زر في دائرة مستقلة (أفضل لـ UI/UX)
                      Row(
                        children: [
                          _buildTopButton(
                            icon: Icons.receipt_long_rounded,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
                          ),
                          const SizedBox(width: 12),
                          _buildTopButton(
                            icon: Icons.shopping_bag_outlined,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. شريط البحث المطور
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث عن قهوتك المفضلة...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: Colors.brown),
                        // إضافة زر فلتر أنيق في نهاية شريط البحث
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.brown[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.brown, size: 20),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. قسم العروض الترويجية (Banners) مع تأثير العلامة المائية
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    height: 150, // زيادة الارتفاع قليلاً ليعطي فخامة
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 300, // عرض البطاقة
                          margin: EdgeInsets.only(
                            right: index == 0 ? 20 : 16,
                            left: index == 1 ? 20 : 0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8D6E63), Color(0xFF4E342E)], // تدرج قهوة عميق
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4E342E).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          // استخدام Stack لإضافة أيقونة خلفية كعلامة مائية
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                bottom: -20,
                                child: Icon(
                                  Icons.coffee_rounded,
                                  size: 120,
                                  color: Colors.white.withOpacity(0.1), // لون شفاف جداً
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'خصم 20%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'على جميع مشروبات\nالإسبريسو اليوم ☕',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
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
                ),
              ),

              // 4. عنوان الفروع
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المقاهي القريبة منك',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      // إضافة زر "عرض الكل" صغير
                      Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. قائمة المقاهي
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(color: Colors.brown),
                        ),
                      ),
                    );
                  } else if (state is HomeError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    );
                  } else if (state is HomeLoaded) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return CafeCard(cafe: state.cafes[index]);
                          },
                          childCount: state.cafes.length,
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة (Widget Helper) لرسم الأزرار العلوية بشكل نظيف ومنع تكرار الكود
  Widget _buildTopButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }
}