import 'package:flutter/material.dart';

const primaryColor = Color(0xFF052A75);

class AppTheme {
  static theme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor, primary: primaryColor),
        appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            )),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(primaryColor),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
      );
}
