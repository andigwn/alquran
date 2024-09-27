import 'package:flutter/material.dart';

const appPurple = Color(0xff431AA1);
const appPurpleVibrant = Color(0xff9345F2);
const appPurpleLight = Color(0xffB9A2D8);
const appPurpleDark = Color(0xff1E0771);
const appWhtie = Color(0xffFAF8FC);
const appOrange = Color(0xffE6704A);

ThemeData themeLight = ThemeData(
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: appPurpleDark),
    brightness: Brightness.light,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: appPurple),
      bodyMedium: TextStyle(color: appPurple),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: appPurpleDark,
    ),
    primaryColor: appPurple,
    tabBarTheme: const TabBarTheme(
        labelColor: appPurpleDark,
        dividerColor: appWhtie,
        unselectedLabelColor: Colors.grey,
        indicatorColor: appPurpleDark),
    appBarTheme: const AppBarTheme(
      backgroundColor: appPurple,
    ));
ThemeData themeDark = ThemeData(
    listTileTheme: const ListTileThemeData(
      textColor: appWhtie,
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: appWhtie),
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: appWhtie),
      bodyMedium: TextStyle(color: appWhtie),
    ),
    scaffoldBackgroundColor: appPurpleDark,
    primaryColor: appPurple,
    tabBarTheme: const TabBarTheme(
      labelColor: appWhtie,
      dividerColor: appPurpleDark,
      unselectedLabelColor: Colors.grey,
      indicatorColor: appWhtie,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: appPurpleDark,
    ));
