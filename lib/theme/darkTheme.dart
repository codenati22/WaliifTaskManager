import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF262626),
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
  ),
  primaryColor: Colors.blue[700],
  scaffoldBackgroundColor: Colors.grey[900],
  cardColor: Colors.grey[800],
  canvasColor: Colors.grey[800],
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[700],
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white70),
    button: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    hintStyle: TextStyle(color: Colors.white70),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent[400]),
);
