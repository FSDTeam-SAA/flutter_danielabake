import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryBG,
    primaryColor: AppColors.primaryButtonDeep,
    colorScheme: ColorScheme.light(primary: AppColors.primaryButtonDeep),

    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: AppColors.primaryWhite,
      displayColor: AppColors.primaryWhite,
    ),

    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.primaryBG,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
    ),
  );
}
