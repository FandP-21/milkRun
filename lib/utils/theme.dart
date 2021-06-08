import 'package:flutter/material.dart';

import 'colorConstants.dart';

class ThemeHelper {
  static ThemeData get getThemeData {
    return ThemeData(
      colorScheme: ColorScheme.light().copyWith(
        primary: AppColors.primaryBlue600,
        primaryVariant: AppColors.primaryBlue300,
        error: AppColors.error,
        onError: AppColors.errorBackground,
        secondary: AppColors.secondaryOrangeColor600,
        secondaryVariant: AppColors.secondaryGreen300,
        surface: AppColors.neutralWhite,
        onSurface: AppColors.neutralBlack,
        background: AppColors.neutralWhite,
        onBackground: AppColors.neutralBlack,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 113, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headline2: TextStyle(
            fontSize: 71, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        headline3: TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
        headline4: TextStyle(
            fontSize: 40, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headline5: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        headline6: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.15),
        subtitle1: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.25),
        caption: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }
}
