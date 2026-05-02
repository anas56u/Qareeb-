import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/constants/app_images.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_state.dart';
import 'package:qareeb/features/home/presentation/screens/home_screen.dart';
import 'CustomTextField.dart'; //
import 'SocialButton.dart'; //
import '../../../../core/widgets/primary_button.dart'; //

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Color primaryColor = const Color(0xFFD08A52);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppImages.logo, width: 150, height: 150),
              const Text(
                'Create New Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // حقل الاسم
              CustomTextField(
                controller: _nameController,
                hintText: 'Full Name',
              ),
              const SizedBox(height: 16),

              // حقل البريد
              CustomTextField(
                controller: _emailController,
                hintText: 'E-mail Address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // حقل كلمة المرور
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // تأكيد كلمة المرور
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                isPassword: true,
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("تم إنشاء الحساب بنجاح!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
                    // نعود لشاشة تسجيل الدخول بعد النجاح
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    text: 'Register',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      // التأكد من تطابق كلمة المرور
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("كلمتي المرور غير متطابقتين"),
                          ),
                        );
                        return;
                      }

                      // التأكد من عدم ترك حقول فارغة
                      if (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("الرجاء تعبئة جميع الحقول"),
                          ),
                        );
                        return;
                      }

                      context.read<AuthCubit>().signUp(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: Divider(color: primaryColor)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Or Register with',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: primaryColor)),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSocialButton(
                    iconWidget: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  buildSocialButton(
                    iconWidget: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  buildSocialButton(
                    iconWidget: const Icon(
                      Icons.apple,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // العودة لتسجيل الدخول
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: primaryColor,
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
    );
  }
}
