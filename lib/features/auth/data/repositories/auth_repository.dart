import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  // تعريف متغيرات فايربيس
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // 💡 Best Practice: Dependency Injection (حقن التبعيات)
  // نمرر الـ instances عبر الـ Constructor. هذا يسهل جداً عمل Unit Testing لاحقاً
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ==========================================
  // 1. دالة إنشاء حساب جديد (Sign Up)
  // ==========================================
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // أ. إنشاء الحساب في Firebase Auth
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        // ب. تجهيز الـ Model الخاص بنا
        UserModel newUser = UserModel(
          uid: firebaseUser.uid,
          name: name,
          email: email,
        );

        // ج. حفظ بيانات المستخدم الإضافية (الاسم) في Firestore
        // سننشئ "مجموعة" (Collection) اسمها users ونضع فيها وثيقة (Document) باسم الـ uid
        await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());

        return newUser;
      } else {
        throw Exception("حدث خطأ غير متوقع أثناء إنشاء الحساب");
      }
    } on FirebaseAuthException catch (e) {
      // معالجة أخطاء الفايربيس الشائعة وترجمتها للمستخدم
      if (e.code == 'weak-password') {
        throw Exception('كلمة المرور ضعيفة جداً.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('البريد الإلكتروني مسجل مسبقاً.');
      }
      throw Exception(e.message ?? 'فشلت عملية التسجيل.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ==========================================
  // 2. دالة تسجيل الدخول (Sign In)
  // ==========================================
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // أ. تسجيل الدخول عبر Firebase Auth
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        // ب. جلب بيانات المستخدم (الاسم) من Firestore
        DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          // إرجاع البيانات على شكل UserModel
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          throw Exception("بيانات المستخدم غير موجودة في قاعدة البيانات.");
        }
      } else {
        throw Exception("حدث خطأ أثناء تسجيل الدخول.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة.');
      }
      throw Exception(e.message ?? 'فشل تسجيل الدخول.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ==========================================
  // 3. دالة تسجيل الخروج (Sign Out)
  // ==========================================
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}