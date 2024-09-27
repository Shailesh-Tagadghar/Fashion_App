import 'package:flutter/material.dart';

class ColorConstants {
  // app colors
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const lightGrayColor = Color.fromARGB(255, 219, 215, 215);
  static const rich = Color(0xff704f38);

  static const primary = MaterialColor(0xff704f38, {
    900: Color(0xff352317), // dark
    800: Color(0xff432e1f), // dark
    700: Color(0xff513827), // dark
    600: Color(0xff60442f), // dark
    500: Color(
        0xff704f38), // primary - neutral (the color is suitable to use on the white surface)
    400: Color(0xff8c705d), // light
    300: Color(0xff9a8070), // light
    200: Color(0xffb6a397), // light
    100: Color(0xffe1d9d4), // light
    50: Color(0xfff0ece9), // light
  });

  static const text = MaterialColor(0xff1f2029, {
    900: Color(0xff282931), // dark
    800: Color(0xff313139), // dark
    700: Color(0xff3a3b41), // dark
    600: Color(0xff3a3b41), // dark
    500: Color(
        0xff43444a), // primary - neutral (the color is suitable to use on the white surface)
    400: Color(0xff4d4d53), // light
    300: Color(0xff57575b), // light
    200: Color(0xffb5b5b9), // light
    100: Color(0xffcdcdd0), // light
    50: Color(0xffe6e6e7), // light
  });

  static const greyColor = Color(0xff797979);
  static const background = Color(0xffededed);

  static const errorColor = Color.fromARGB(255, 204, 43, 43);

  static const successColor = Color.fromARGB(255, 23, 116, 77);
  static const Color transparent = Color.fromRGBO(0, 0, 0, 0.9);
}
