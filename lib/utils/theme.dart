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
      textTheme: textTheme,
      appBarTheme: AppBarTheme().copyWith(
        color: AppColors.neutralWhite,
        centerTitle: true,
        foregroundColor: AppColors.neutralBlack,
        textTheme: textTheme,
        elevation: 1,
        iconTheme: IconThemeData().copyWith(color: AppColors.neutralBlack),
      ),
    );
  }

  static TextTheme get textTheme {
    return TextTheme(
      headline1: TextStyle(
        fontSize: 113,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: AppColors.neutralBlack,
      ),
      headline2: TextStyle(
        fontSize: 71,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: AppColors.neutralBlack,
      ),
      headline3: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: AppColors.neutralBlack,
      ),
      headline4: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.neutralBlack,
      ),
      headline5: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.neutralBlack,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.15,
        color: AppColors.neutralBlack,
      ),
      subtitle1: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: AppColors.neutralBlack,
      ),
      subtitle2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.neutralBlack,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.neutralBlack,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.neutralBlack,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.25,
        color: AppColors.neutralWhite,
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.neutralBlack,
      ),
      overline: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: AppColors.neutralBlack,
      ),
    );
  }
}
