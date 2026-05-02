import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/constants/app_images.dart';
import 'package:qareeb/core/widgets/primary_button.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_state.dart';
import 'package:qareeb/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:qareeb/features/auth/presentation/widgets/CustomTextField.dart';
import 'package:qareeb/features/auth/presentation/widgets/SocialButton.dart';
import 'package:qareeb/features/home/presentation/screens/home_screen.dart';

class LoginBody extends StatefulWidget {
  LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // اللون النحاسي/الذهبي المستخدم بكثرة في التصميم
  final Color primaryColor = const Color(0xFFD08A52);
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. صورة الخلفية (في الأسفل)
        // 1. صورة الخلفية (في الأسفل)
        // 1. صورة الخلفية السفلية المدمجة بتدرج لوني
        // 1. صورة الخلفية (تغطي الشاشة بالكامل)
        SizedBox(
          width: double.infinity,
          height: double.infinity, // هذا السطر يجعلها تملأ الشاشة طولاً
          child: Stack(
            children: [
              // الطبقة أ: الصورة الأصلية تملأ الشاشة
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(AppImages.auth_picture, fit: BoxFit.cover),
              ),

              // الطبقة ب: التدرج اللوني فوق الصورة بالكامل لضمان وضوح حقول الإدخال
            ],
          ),
        ),
        // 2. المحتوى الرئيسي القابل للتمرير
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // أيقونة فنجان القهوة
                Image.asset(AppImages.logo, width: 150, height: 150),

                // العنوان
                const Text(
                  'Welcome to Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // حقل الإيميل
                CustomTextField(
                  controller: _emailController,
                  hintText: 'E-mail Address',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // حقل الباسوورد
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 12),

                // زر نسيت كلمة المرور
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // زر تسجيل الدخول (Sign in) النظيف
                // تغليف الزر بـ BlocConsumer ليتفاعل مع الـ Cubit
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    // 1. إذا فشل تسجيل الدخول، نظهر رسالة خطأ (SnackBar)
                    if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    // 2. إذا نجح تسجيل الدخول، ننتقل للشاشة الرئيسية
                    else if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم تسجيل الدخول بنجاح!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
                      // هنا سنضيف كود الانتقال للشاشة الرئيسية (Home) لاحقاً
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      text: 'Sign in',
                      // نمرر true للزر إذا كانت الحالة الحالية هي حالة "تحميل"
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        // التحقق المبدئي (Validation) البسيط
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("الرجاء إدخال البريد وكلمة المرور"),
                            ),
                          );
                          return; // إيقاف التنفيذ إذا كانت الحقول فارغة
                        }

                        // استدعاء دالة تسجيل الدخول من الـ Cubit
                        context.read<AuthCubit>().signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // خط فاصل مع كلمة (Or Login with)
                Row(
                  children: [
                    Expanded(child: Divider(color: primaryColor, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Or Login with',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: primaryColor, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 32),

                // أزرار السوشيال ميديا
                // أزرار السوشيال ميديا بعد التحسين
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. زر فيسبوك
                    buildSocialButton(
                      iconWidget: const Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        // كود تسجيل الدخول بفيسبوك سيوضع هنا
                        print("Facebook Login Clicked");
                      },
                    ),

                    // 2. زر جوجل (مررنا له Text بدلاً من Icon)
                    buildSocialButton(
                      iconWidget: const Text(
                        'G',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // كود تسجيل الدخول بجوجل سيوضع هنا
                        print("Google Login Clicked");
                      },
                    ),

                    // 3. زر أبل (بديل تويتر - وهو أيقونة قياسية في Flutter)
                    buildSocialButton(
                      iconWidget: const Icon(
                        Icons.apple,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        // كود تسجيل الدخول بأبل سيوضع هنا
                        print("Apple Login Clicked");
                      },
                    ),
                  ],
                ),

                // مسافة مرنة لدفع النص الأخير للأسفل إذا كانت الشاشة طويلة
                const SizedBox(height: 50),

                // نص تسجيل حساب جديد (في الأسفل فوق الصورة)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account ? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        ); // الانتقال لصفحة التسجيل
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
