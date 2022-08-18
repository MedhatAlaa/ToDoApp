import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  static var lightTheme = ThemeData(
    canvasColor: Colors.white,
    primarySwatch: Colors.pink,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.grey,
    ),
  );
  static var darkTheme = ThemeData(
    canvasColor: Colors.black,
    primarySwatch: Colors.pink,
    appBarTheme: const AppBarTheme(
      color: Colors.teal,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    bottomSheetTheme:const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
  );
}
