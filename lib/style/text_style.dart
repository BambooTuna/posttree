import 'package:flutter/material.dart';

import 'colors.dart';

class CustomThemeData {
  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      indicatorColor: Colors.greenAccent,
      tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Creates border
              color: Colors.greenAccent),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.blueGrey)

      // primaryColor: ThemeColors.primaryColor,
      // accentColor: ThemeColors.secondaryColor,
      // cardColor: ThemeColors.quaternaryColor,
      //
      // // Define the default font family.
      // fontFamily: 'Georgia',
      //
      // // Define the default TextTheme. Use this to specify the default
      // // text styling for headlines, titles, bodies of text, and more.
      // textTheme: TextTheme(
      //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      // )
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
