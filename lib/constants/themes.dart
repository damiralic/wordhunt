import 'package:flutter/material.dart';
import 'package:wordhunt/constants/colors.dart';

final ThemeData lightTheme = ThemeData(
    primaryColorLight: lightThemeLightShade,
    primaryColorDark: lightThemeDarkShade,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: const TextTheme().copyWith(
        bodyMedium:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)));

final ThemeData darkTheme = ThemeData(
    primaryColorLight: darkThemeLightShade,
    primaryColorDark: darkThemeDarkShade,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Color.fromARGB(255, 186, 188, 235)),
        backgroundColor: Color.fromARGB(255, 17, 41, 45),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
    scaffoldBackgroundColor: Color.fromARGB(255, 17, 41, 45),
    dividerColor: darkThemeLightShade,
    brightness: Brightness.dark,
    textTheme: const TextTheme().copyWith(
        bodyMedium:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
