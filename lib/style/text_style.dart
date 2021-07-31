import 'package:flutter/material.dart';

import 'colors.dart';

const MaterialColor customSwatch = const MaterialColor(
  0xffe55f48,
  const <int, Color>{
    50: const Color(0xffce5641 ),//10%
    100: const Color(0xffb74c3a),//20%
    200: const Color(0xffa04332),//30%
    300: const Color(0xff89392b),//40%
    400: const Color(0xff733024),//50%
    500: const Color(0xff5c261d),//60%
    600: const Color(0xff451c16),//70%
    700: const Color(0xff2e130e),//80%
    800: const Color(0xff170907),//90%
    900: const Color(0xff000000),//100%

  },
);

class CustomThemeData {
  static ThemeData light = ThemeData(
    // primarySwatch: customSwatch,
    brightness: Brightness.light,
    // indicatorColor: ThemeColors.secondaryColor,
    // tabBarTheme: TabBarTheme(
    //     indicatorSize: TabBarIndicatorSize.tab,
    //     // indicator: BoxDecoration(
    //     //     borderRadius: BorderRadius.circular(50), // Creates border
    //     //     color: ThemeColors.secondaryColor),
    //     labelColor: ThemeColors.primaryTextColor,
    //     unselectedLabelColor: Colors.blueGrey),
    // buttonColor: ThemeColors.quaternaryColor,
    //
    // primaryColor: ThemeColors.primaryColor,
    // accentColor: ThemeColors.secondaryColor,
    // // cardColor: ThemeColors.quaternaryColor,
    //
    fontFamily: 'Raleway',
  );
}

// import 'colors.dart';
//
// class TextStyles {
//   static TextStyle headlineBlue = TextStyle(
//     fontFamily: 'Quicksand-Bold',
//     fontSize: 50,
//     color: ThemeColors.blue,
//   );
//
//   static TextStyle headlineBlack = TextStyle(
//     fontFamily: 'Quicksand-Bold',
//     fontSize: 50,
//     color: ThemeColors.black,
//   );
//
//   static TextStyle captionBlack = TextStyle(
//     fontFamily: 'Quicksand-Bold',
//     fontSize: 16,
//     color: ThemeColors.black,
//   );
// }
