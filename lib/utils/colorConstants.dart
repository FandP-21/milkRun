import 'package:flutter/widgets.dart';

class Hexcolor extends Color {
  Hexcolor(String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class AppColors {
  //Primary Colors
  static Color get primaryBlue600 {
    return Hexcolor('#0A53FB');
  }

  static Color get primaryBlue300 {
    return Hexcolor('#CFDDFE');
  }

  static Color get secondaryOrangeColor600 {
    return Hexcolor('##FF784B');
  }

  //Secondary Colors
  static Color get secondaryOrange300 {
    return Hexcolor('#FFE4DA');
  }

  static Color get secondaryGreen600 {
    return Hexcolor('#3CD278');
  }

  static Color get secondaryGreen300 {
    return Hexcolor('#D8F6E4');
  }

  static Color get secondaryYellow600 {
    return Hexcolor('#FFC837');
  }

  static Color get secondaryYellow300 {
    return Hexcolor('#F7E9C1');
  }

  static Color get secondaryPink600 {
    return Hexcolor('#D250E6');
  }

  static Color get secondaryPink300 {
    return Hexcolor('#F6DCFA');
  }

  static Color get secondaryRed600 {
    return Hexcolor('#EC4D27');
  }

  static Color get secondaryRed300 {
    return Hexcolor('#FBDBD4');
  }

//Neutral Colors

  static Color get neutralBlack {
    return Hexcolor('#000000');
  }

  static Color get neutralWhite {
    return Hexcolor('##FFFFFF');
  }

  static Color get neutralGrey900 {
    return Hexcolor('#333333');
  }

  static Color get neutralGrey800 {
    return Hexcolor('#666666');
  }

  static Color get neutralGrey700 {
    return Hexcolor('#808080');
  }

  static Color get neutralGrey600 {
    return Hexcolor('##B3B3B3');
  }

  static Color get neutralGrey500 {
    return Hexcolor('#CCCCCC');
  }

  static Color get neutralGrey400 {
    return Hexcolor('#D7D7D7');
  }

  static Color get neutralGrey300 {
    return Hexcolor('#E6E6E6');
  }

  static Color get neutralGrey200 {
    return Hexcolor('#F8F8F8');
  }

  //System Colors

  static Color get success {
    return Hexcolor('#008060');
  }

  static Color get successBackground {
    return Hexcolor('#CCE6DF');
  }

  static Color get warning {
    return Hexcolor('#FFC453');
  }

  static Color get warningBackground {
    return Hexcolor('#FFF3DD');
  }

  static Color get error {
    return Hexcolor('#D82C0D');
  }

  static Color get errorBackground {
    return Hexcolor('#F7D5CF');
  }
}
