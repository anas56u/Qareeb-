import 'package:flutter/material.dart';
import 'package:qareeb/core/constants/app_images.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon; // جعلنا الأيقونة اختيارية (Nullable) بإضافة علامة الاستفهام
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon, // أزلنا كلمة required
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        // نتحقق إذا تم تمرير أيقونة نعرضها، وإلا لا نعرض شيئاً (null)
        prefixIcon: prefixIcon != null 
            ? Icon(prefixIcon, color: const Color(0xFFD08A52)) 
            : null,
        filled: true,
        // لون الخلفية للحقل الداكن (قريب جداً من الأسود)
        fillColor: const Color(0xFF1A1A1A), 
        // مسافة داخلية (Padding) مريحة للنص
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        
        // إزالة الحواف بالكامل ليتطابق مع التصميم المرفق
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD08A52), width: 1),
        ),
      ),
    );
  }
}

// افترض أننا أضفنا مسار الصورة هنا
// import '../../../../core/constants/app_images.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // اللون النحاسي/الذهبي المستخدم بكثرة في التصميم
  final Color primaryColor = const Color(0xFFD08A52);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // استخدمنا Stack لكي نضع صورة القهوة في طبقة الخلفية السفلية
      body: Stack(
        children: [
          // 1. صورة الخلفية (في الأسفل)
         // 1. صورة الخلفية (في الأسفل)
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45, // كبرناها لتأخذ 45% من الشاشة وتظهر بوضوح
              child: Stack(
                children: [
                  // الصورة نفسها بدون فلاتر تعتيم
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      AppImages.auth_picture, 
                      fit: BoxFit.cover,
                    ),
                  ),
                  
                  // التدرج اللوني (Gradient) لدمج الصورة مع الخلفية السوداء العلوية
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black, // أسود صلب من الأعلى ليخفي حافة الصورة
                          Colors.black.withOpacity(0.0), // شفاف من الأسفل لتظهر القهوة
                        ],
                        // الـ stops تحدد أين يبدأ التدرج وأين ينتهي بدقة
                        stops: const [0.0, 0.4], 
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. المحتوى الرئيسي القابل للتمرير
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // أيقونة فنجان القهوة
                    Icon(
                      Icons.coffee_outlined, // يمكنك استبدالها بصورة SVG للوجو التطبيق
                      size: 64,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    
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
                    const SizedBox(height: 48),

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

                    // زر تسجيل الدخول (Sign in)
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // خط فاصل مع كلمة (Or Login with)
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: primaryColor, thickness: 1),
                        ),
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
                        Expanded(
                          child: Divider(color: primaryColor, thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // أزرار السوشيال ميديا
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSocialButton(Icons.facebook, Colors.white),
                        _buildSocialButton(Icons.g_mobiledata, Colors.white, isGoogle: true),
                        _buildSocialButton(Icons.flutter_dash, Colors.white), // استخدمنا Dash كبديل لتويتر مؤقتاً
                      ],
                    ),
                    
                    // مسافة مرنة لدفع النص الأخير للأسفل إذا كانت الشاشة طويلة
                    const SizedBox(height: 48),

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
                            // الانتقال لصفحة التسجيل
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
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت مخصص لبناء أزرار السوشيال ميديا (Best Practice: DRY)
  Widget _buildSocialButton(IconData icon, Color iconColor, {bool isGoogle = false}) {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // نفس لون حقول الإدخال
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {},
        icon: isGoogle 
            ? const Text('G', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
            : Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}