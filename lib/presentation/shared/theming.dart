import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        headline1: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        headline2: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headline3: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        headline4: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        headline5: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        headline6: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        bodyText1: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodyText2: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: kText1Color,
        ),
        button: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        subtitle2: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        caption: GoogleFonts.inter(
          color: kText1Color,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
