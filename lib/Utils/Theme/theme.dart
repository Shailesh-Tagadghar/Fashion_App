import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Theme/app_fonts.dart';
import 'package:flutter/material.dart';

TextTheme lightTextTheme = TextTheme(
  headlineLarge:
      AppTypography.headlineLarge.copyWith(color: ColorConstants.text),
  headlineMedium:
      AppTypography.headlineMedium.copyWith(color: ColorConstants.text),
  headlineSmall:
      AppTypography.headlineSmall.copyWith(color: ColorConstants.text),
  displayLarge:
      AppTypography.displayLarge.copyWith(color: ColorConstants.text.shade700),
  displayMedium:
      AppTypography.displayMedium.copyWith(color: ColorConstants.text.shade700),
  displaySmall:
      AppTypography.displaySmall.copyWith(color: ColorConstants.text.shade700),
  bodyLarge: AppTypography.bodyLarge.copyWith(color: ColorConstants.text),
  bodyMedium:
      AppTypography.bodyMedium.copyWith(color: ColorConstants.text.shade400),
  bodySmall:
      AppTypography.bodySmall.copyWith(color: ColorConstants.text.shade500),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: lightTextTheme,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.primary),
  appBarTheme: const AppBarTheme(
    color: ColorConstants.whiteColor,
  ),
  tabBarTheme: TabBarTheme(
      dividerColor: ColorConstants.primary.withOpacity(0.1),
      indicatorColor: ColorConstants.primary),
  splashColor: ColorConstants.primary.shade400.withOpacity(0.1),
  splashFactory: InkRipple.splashFactory,
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.primary),
    buttonColor: ColorConstants.primary,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      // backgroundColor: MaterialStatePropertyAll(ColorConstants.primary),

      backgroundColor: WidgetStatePropertyAll(ColorConstants.primary),

      textStyle:
          // MaterialStatePropertyAll(TextStyle(color: ColorConstants.whiteColor)),

          WidgetStatePropertyAll(TextStyle(color: ColorConstants.whiteColor)),

      // shape: MaterialStatePropertyAll(RoundedRectangleBorder(

      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(48)))),

      // elevation: MaterialStatePropertyAll(0),
      elevation: WidgetStatePropertyAll(0),
    ),
  ),
);
