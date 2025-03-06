import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String leftIconPath;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.leftIconPath,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SvgPicture.asset(widget.leftIconPath, width: 24, height: 24, color: AppColors.textPrimary),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          if (widget.isPassword)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: SvgPicture.asset(
                  _obscureText ? "assets/hide_icon.svg" : "assets/unlock_icon.svg",
                  width: 24,
                  height: 24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
