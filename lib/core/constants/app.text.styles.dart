import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _spaceGrotesk({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    double letterSpacing = 0,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height / fontSize,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle get h1Bold => _spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 36,
        letterSpacing: 28 * -0.03,
      );

  static TextStyle h1DynamicBold(BuildContext context, {Color? color}) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final fontSize = (screenHeight * 0.031).clamp(20.0, 26.0);
    return _spaceGrotesk(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      height: 32,
      letterSpacing: fontSize * -0.03,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle get h1Regular => _spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 36,
        letterSpacing: 28 * -0.03,
      );

  static TextStyle get h2Bold => _spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 30,
        letterSpacing: 24 * -0.02,
      );

  static TextStyle get h2Regular => _spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 30,
        letterSpacing: 24 * -0.02,
      );

  static TextStyle get h3Bold => _spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 26,
        letterSpacing: 20 * -0.01,
      );

  static TextStyle get h3Regular => _spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 26,
        letterSpacing: 20 * -0.01,
      );

  static TextStyle get b1Bold => _spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 24,
      );

  static TextStyle get b1Regular => _spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24,
      );

  static TextStyle get b2Bold => _spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20,
      );

  static TextStyle get b2Regular => _spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20,
      );

  static TextStyle get s1Bold => _spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 18,
      );

  static TextStyle get s1Regular => _spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 18,
      );

  static TextStyle get s2 => _spaceGrotesk(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 12,
      );
}
