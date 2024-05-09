  import 'dart:ui';

  import 'package:flutter/material.dart';

  class Styles {
    static ThemeData themeData(bool isDarkTheme, BuildContext context) {
      return ThemeData(
        colorScheme: isDarkTheme
            ? const ColorScheme.dark(
                primary: Color(0x1E1E1E2F),
                secondary: Color.fromRGBO(1, 78, 68, 255),
                tertiary: Colors.white,
                surface: Color.fromRGBO(1, 78, 68, 1),
                brightness: Brightness.dark)
            : const ColorScheme.light(
                primary: Color(0x1E1E1E2F),
                secondary: Colors.white,
                surface: Color.fromRGBO(1, 78, 68, 1),
                tertiary: Color(0xFF26282F),
                brightness: Brightness.light),
      );
    }
  }
