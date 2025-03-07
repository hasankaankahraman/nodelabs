import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final String? iconPath;
  final double? fontSize;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? borderRadius;
  final double? iconSize;
  final double? minWidth; // ✅ Ekledik!

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.iconPath,
    this.fontSize,
    this.paddingHorizontal,
    this.paddingVertical,
    this.borderRadius,
    this.iconSize,
    this.minWidth, // ✅ Ekledik!
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minWidth ?? screenWidth * 0.25, // ✅ Artık butonun minimum genişliği belirlenebilir
        ),
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? screenWidth * 0.05,
          vertical: paddingVertical ?? 10,
        ),
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SvgPicture.asset(
                  iconPath!,
                  color: textColor ?? Colors.white,
                  height: iconSize ?? 20,
                  width: iconSize ?? 20,
                ),
              ),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize ?? 16,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
