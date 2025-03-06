import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';

class CustomSocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;
  final Color? borderColor; // ✅ Kenar çizgisi rengi opsiyonel

  const CustomSocialButton({
    Key? key,
    required this.iconPath,
    required this.onPressed,
    this.borderColor, // ✅ Kenar rengi parametre olarak ekledim
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.socialButtonBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: borderColor ?? AppColors.border, // ✅ Varsayılan kenar rengi
            width: 1.5, // ✅ Kenarlık kalınlığı
          ),
        ),
        child: Center(
          child: SvgPicture.asset(iconPath, width: 24, height: 24, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
