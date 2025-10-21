import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration with consistent colors and typography matching kiosqueeing design system

// Primary color palette - from kiosqueeing design system
const Color primaryColor = Color(0xFF085fc5); // kiosqueeing-primary (denim-800)
const Color primaryHoverColor = Color(0xFF0d539b); // kiosqueeing-primary-hover
const Color primaryDarkColor = Color(0xFF053a78); // darker version of primary for kiosk elements
const Color secondaryColor = Color(0xFF334155); // kiosqueeing-text
const Color backgroundColor = Color(0xFFF9FAFB); // kiosqueeing-background

// Status colors - from kiosqueeing design system
const Color successColor = Color(0xFF22C55E); // kiosqueeing-positive
const Color errorColor = Color(0xFFEF4444); // kiosqueeing-negative
const Color warningColor = Color(0xFFF97316); // kiosqueeing-warning
const Color infoColor = Color(0xFF1eafff); // kiosqueeing-info

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: successColor, // Using success color as accent/tertiary
    error: errorColor,
    background: backgroundColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.interTextTheme(), // Using Inter font from kiosqueeing design system
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      elevation: 1,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    clipBehavior: Clip.antiAlias,
    color: Colors.white,
    shadowColor: Colors.black.withOpacity(0.1),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: errorColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    labelStyle: TextStyle(color: secondaryColor),
    hintStyle: TextStyle(color: Colors.grey[500]),
  ),
);