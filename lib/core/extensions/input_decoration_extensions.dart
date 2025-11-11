import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension InputDecorationExtensions on BuildContext {
  InputDecoration primaryInputDecoration({
    double borderRadius = 28.0,
    double contentPadding = 16.0,
  }) => InputDecoration(
    filled: true,
    suffixIconColor: AppColors.iconColor,
    contentPadding: EdgeInsets.all(contentPadding),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: AppColors.primaryButtonBright),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: AppColors.primaryButtonBright),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: AppColors.primaryButtonBright, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: AppColors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: AppColors.red, width: 1.5),
    ),
    hintStyle: TextStyle(
      color: AppColors.hintText,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: TextStyle(
      color: AppColors.hintText,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: TextStyle(
      color: AppColors.red,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}
