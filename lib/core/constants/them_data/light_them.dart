import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';

ThemeData lightTheme = ThemeData(
  // primarySwatch: Colors.blue,
  primaryColor: AppLightColors.primaryColor,
  scaffoldBackgroundColor: AppLightColors.backGroundColor,
  appBarTheme:  AppBarTheme(
    centerTitle: true,
    backgroundColor: AppLightColors.backGroundColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
);

