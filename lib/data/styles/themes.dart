import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';


ThemeData lightTheme = ThemeData(
  //primarySwatch: RecoverColors.myColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white,),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.deepPurple,
    elevation: 5.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: RecoverColors.myColor,
      statusBarBrightness: Brightness.light,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: RecoverColors.myColor,
    unselectedItemColor: Colors.grey,
    elevation: 30.0,
    backgroundColor: Colors.white,
  ),
  textTheme:  const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 1.0,
    ),
  ),
);
