import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading; // ميزة احترافية لحالة التحميل

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56, // ارتفاع قياسي ومريح للأصابع
    this.width = double.infinity, // يملأ الشاشة عرضياً افتراضياً
    this.backgroundColor = const Color(0xFFD08A52), // اللون النحاسي/الذهبي
    this.textColor = Colors.black87,
    this.isLoading = false, // افتراضياً لا يوجد تحميل
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // إزالة الظل إذا أردت تصميماً مسطحاً (Flat Design) - اختياري
          elevation: 0, 
        ),
        // إذا كان يحمل، نقوم بتعطيل الضغط بتمرير دالة فارغة
        onPressed: isLoading ? () {} : onPressed, 
        
        // إذا كان يحمل، نعرض مؤشر، وإلا نعرض النص
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}