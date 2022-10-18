import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: defaultColor,
  textTheme: TextTheme(
      headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      headline5: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      subtitle1: TextStyle(
          fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
  scaffoldBackgroundColor: HexColor('333739'),
  floatingActionButtonTheme: FloatingActionButtonThemeData(),
  appBarTheme: AppBarTheme(
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
// so we can change theme of  the statusbar
    systemOverlayStyle: SystemUiOverlayStyle(
// Status bar color
      statusBarColor: HexColor('333739'),
// statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 20.0,
      backgroundColor: HexColor('333739'),
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey),
);

// final darkTheme = ThemeData(
//   textTheme: TextTheme(
//       headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       headline5: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       subtitle1: TextStyle(
//           fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
//   scaffoldBackgroundColor: HexColor('333739'),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(),
//   appBarTheme: AppBarTheme(
//     backgroundColor: HexColor('333739'),
//     elevation: 0.0,
// // so we can change theme of  the statusbar
//     systemOverlayStyle: SystemUiOverlayStyle(
// // Status bar color
//       statusBarColor: HexColor('333739'),
// // statusBarBrightness: Brightness.light,
//       statusBarIconBrightness: Brightness.light,
//     ),
//     iconTheme: IconThemeData(
//       color: Colors.white,
//     ),
//     titleTextStyle: TextStyle(
//         color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       type: BottomNavigationBarType.fixed,
//       elevation: 20.0,
//       backgroundColor: HexColor('333739'),
//       selectedItemColor: defaultColor,
//       unselectedItemColor: Colors.grey),
//   primarySwatch: defaultColor,
// );
final lightTheme = ThemeData(
  textTheme: TextTheme(
      headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      headline5: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      subtitle1: TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
  scaffoldBackgroundColor: Colors.white,
  floatingActionButtonTheme: FloatingActionButtonThemeData(),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
// so we can change theme of  the statusbar
    systemOverlayStyle: SystemUiOverlayStyle(
// Status bar color
      statusBarColor: Colors.white,
// statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 20.0,
      selectedItemColor: defaultColor),
  primarySwatch: defaultColor,
);
