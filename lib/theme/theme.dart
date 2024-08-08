import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade300,
    secondary: Colors.white,
  ),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    labelMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade800,
    secondary: Colors.white,
  ),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    labelMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
