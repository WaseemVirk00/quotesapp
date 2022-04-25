import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeText {
  static final headline = GoogleFonts.dosis(textStyle: _headline.copyWith());
  static final subheading = GoogleFonts.dosis(textStyle: _subheading.copyWith());

  static const _headline = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic);

  static const _subheading = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
}
