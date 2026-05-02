
class UserModel {
  final String uid; // المعرف الفريد من فايربيس
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // دالة لتحويل البيانات إلى Map لكي نتمكن من رفعها إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(), // لحفظ وقت إنشاء الحساب
    };
  }

  // دالة لتحويل الـ Map القادم من Firestore إلى كلاس UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}