import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  // Ana oluşturucu fonksiyonumuz
  static TextTheme buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      // BÜYÜK SAYAÇ RAKAMLARI (Örn: 25:00)
      displayLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontSize: 60,
        fontWeight: FontWeight.bold,
        letterSpacing: -1.0, // Rakamlar biraz sıkı dursun
      ),

      // ANA BAŞLIKLAR (Örn: Daily Goal, Welcome back)
      headlineMedium: GoogleFonts.poppins(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),

      // KART BAŞLIKLARI (Örn: My Goals, Statistics)
      titleLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

      // STANDART METİNLER
      bodyLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      // İKİNCİL/AÇIKLAMA METİNLERİ (Örn: Focus Timer Ready, Keep up the momentum)
      bodyMedium: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),

      // KÜÇÜK ETİKETLER / TARİHLER
      labelSmall: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),

      // BUTON YAZILARI
      labelLarge: GoogleFonts.poppins(
        color: Colors.white, // Buton içi genelde beyaz olur
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
