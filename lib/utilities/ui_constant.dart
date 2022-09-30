import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class UIConstant {
  static ThemeData get getDefaultThemeData {
    return ThemeData(
      primarySwatch: const MaterialColor(0XFF333340, <int, Color>{
        50: Color.fromRGBO(51, 51, 64, .1),
        100: Color.fromRGBO(51, 51, 64, .2),
        200: Color.fromRGBO(51, 51, 64, .3),
        300: Color.fromRGBO(51, 51, 64, .4),
        400: Color.fromRGBO(51, 51, 64, .5),
        500: Color.fromRGBO(51, 51, 64, .6),
        600: Color.fromRGBO(51, 51, 64, .7),
        700: Color.fromRGBO(51, 51, 64, .8),
        800: Color.fromRGBO(51, 51, 64, .9),
        900: Color.fromRGBO(51, 51, 64, 1),
      }),
      // textTheme: GoogleFonts.abelTextTheme(),
    );
  }
}
