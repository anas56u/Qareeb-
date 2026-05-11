import 'package:cloud_firestore/cloud_firestore.dart';

class CafeModel {
  final String id;
  final String name;
  final String imageUrl;
  final double distance;
  final bool isOpen;

  CafeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.isOpen,
  });

  // دالة لتحويل بيانات Firestore إلى كائن CafeModel
  factory CafeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CafeModel(
      id: doc.id, // نأخذ الـ ID الخاص بالوثيقة من فايربيس
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      distance: (data['distance'] ?? 0.0).toDouble(),
      isOpen: data['isOpen'] ?? false,
    );
  }

  // دالة لتحويل الكائن إلى خريطة (Map) لرفعه إلى فايربيس
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'distance': distance,
      'isOpen': isOpen,
    };
  }
}