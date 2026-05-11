import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class MenuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getShopMenu(String shopId) async {
    try {
      // ركز هنا: ندخل للـ shops ثم للـ doc المحدد ثم لمجموعة products الفرعية
      QuerySnapshot snapshot = await _firestore
          .collection('shops')
          .doc(shopId)
          .collection('products')
          .get();

      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('فشل في جلب المنيو: $e');
    }
  }
}                                                       