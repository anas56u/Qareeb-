
import 'package:flutter/material.dart';

Widget buildSocialButton({required Widget iconWidget, required VoidCallback onPressed}) {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // نفس لون حقول الإدخال
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed, // تمرير دالة الضغط لتكون ديناميكية
        icon: iconWidget, // تمرير الـ Widget بالكامل (سواء كان Icon أو Text أو Image)
      ),
    );
  }