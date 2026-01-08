import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final Widget icon; // Widget almaya devam ediyoruz (Google için şart)
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        // DİKKAT: .icon kurucusu, hizalamayı otomatik yapar
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.transparent,
          // İkon ile yazı arasındaki boşluk ayarı (gerekirse)
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
