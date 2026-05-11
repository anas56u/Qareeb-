import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/models/cafe_model.dart'; // نحتاج مودل الكافيه
import '../../data/repositories/menu_repository.dart';
import '../../logic/menu_cubit/menu_cubit.dart';
import '../../logic/menu_cubit/menu_state.dart';
import '../widgets/product_card.dart';

class MenuScreen extends StatelessWidget {
  final CafeModel cafe;

  const MenuScreen({Key? key, required this.cafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // بمجرد فتح الشاشة، نطلب من الـ Cubit جلب المنيو الخاص بـ id هذا الكافيه
      create: (context) => MenuCubit(MenuRepository())..fetchMenu(cafe.id),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. الهيدر الفخم (SliverAppBar)
            SliverAppBar(
              expandedHeight: 250, // ارتفاع الصورة
              pinned: true, // ليبقى شريط العنوان ثابت بالأعلى عند النزول
              backgroundColor: Colors.brown,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  cafe.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(cafe.imageUrl, fit: BoxFit.cover),
                    // طبقة سوداء خفيفة لتوضيح النص فوق الصورة
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. حالة الكافيه ومسافته (معلومة سريعة)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(Icons.directions_walk, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text('${cafe.distance} كم', style: TextStyle(color: Colors.grey[600])),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: cafe.isOpen ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cafe.isOpen ? 'مفتوح الآن' : 'مغلق',
                        style: TextStyle(color: cafe.isOpen ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. قائمة المشروبات مربوطة بـ Firebase عبر الـ Cubit
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                if (state is MenuLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(color: Colors.brown),
                      ),
                    ),
                  );
                } else if (state is MenuError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text(state.message)),
                  );
                } else if (state is MenuLoaded) {
                  if (state.products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('لا يوجد منيو متاح حالياً 🥲')),
                    );
                  }
                  
                  // رسم المنتجات
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(product: state.products[index]);
                        },
                        childCount: state.products.length,
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
    );
  }
}