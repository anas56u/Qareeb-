import 'package:flutter/material.dart';

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
