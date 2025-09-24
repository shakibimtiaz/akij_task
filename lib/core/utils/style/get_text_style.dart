import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable text style generator for Poppins font
TextStyle getTextStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  double letterSpacing = 0,
  double height = 1.2,
  TextDecoration decoration = TextDecoration.none,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
    decoration: decoration,
  );
}
