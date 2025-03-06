import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nodelabs/core/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( // ✅ Ekran genişliğini dinamik al
      builder: (context, constraints) {
        // Buton genişliği = (Toplam alan - padding - boşluk) / 2
        double buttonWidth = (constraints.maxWidth - 40 - 20) / 2;
        // 40 = horizontal padding (20*2), 20 = SizedBox

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            children: [
              _buildNavItem("assets/home_icon.svg", "Anasayfa", 0, buttonWidth),
              const SizedBox(width: 20),
              _buildNavItem("assets/profile_icon.svg", "Profil", 1, buttonWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index, double width) {
    bool isSelected = selectedIndex == index;
    Color iconColor = isSelected ? AppColors.textPrimary : AppColors.border;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width, // ✅ Dinamik genişlik
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : AppColors.border,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}