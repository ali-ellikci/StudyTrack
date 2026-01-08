import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(
    0xFF5E3AE0,
  ); // O morumsu mavi ana renk
  static const Color backgroundLight = Color(
    0xFFF5F7FA,
  ); // Çok açık gri arka plan
  static const Color surfaceLight = Color(0xFFFFFFFF); // Kartlar için beyaz
  static const Color textPrimaryLight = Color(0xFF2C3144); // Koyu başlıklar
  static const Color textSecondaryLight = Color(0xFF9CA3AF); // Alt metinler

  // Dark Theme Colors
  static const Color primaryDark = Color(
    0xFF3B82F6,
  ); // Daha parlak mavi (Dark mod için)
  static const Color backgroundDark = Color(0xFF111827); // Koyu lacivert/siyah
  static const Color surfaceDark = Color(0xFF1F2937); // Koyu gri kartlar
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Common Colors (Accent & Status)
  static const Color accentOrange = Color(
    0xFFFF8A65,
  ); // "3 Day Streak" kısmındaki turuncu
  static const Color accentGreen = Color(0xFF4ADE80); // İlerleme çubukları vb.
  static const Color error = Color(0xFFEF4444);
}
