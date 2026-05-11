import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final List<Map<String, dynamic>> items; // تفاصيل المشروبات
  final double totalAmount;
  final DateTime orderDate;
  final String status; // 'pending', 'preparing', 'ready', 'completed'
  final String paymentMethod;
  final String pickupTime;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.paymentMethod,
    required this.pickupTime,
  });

  // تحويل البيانات لشكل يفهمه Firestore
  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'totalAmount': totalAmount,
      'orderDate': Timestamp.fromDate(orderDate),
      'status': status,
      'paymentMethod': paymentMethod,
      'pickupTime': pickupTime,
    };
  }
}