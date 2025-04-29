import 'package:vtcode/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle headline1(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle headline2(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle button(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}