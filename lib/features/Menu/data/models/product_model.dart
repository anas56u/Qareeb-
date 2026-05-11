import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final Map<String, dynamic> customizations; // مهمة جداً لشاشة التخصيص لاحقاً

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.customizations,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(), // لضمان عدم حدوث خطأ إذا كان السعر int
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'عام',
      customizations: data['customizations'] ?? {},
    );
  }
}