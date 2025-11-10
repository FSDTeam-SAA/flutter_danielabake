import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryBlack,
    // primaryColor: AppColors.primaryWhite,
    colorScheme: ColorScheme.dark(primary: AppColors.primaryWhite),

    textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColors.primaryWhite,
      displayColor: AppColors.primaryWhite,
    ),

    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.primaryBlack,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
      centerTitle: false,
    ),
  );
}
