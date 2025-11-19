import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    fontFamily: 'BeVietnamPro',
    brightness: Brightness.dark,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      // color: Colors.black,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      // iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent, // Background color of AppBar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness: Brightness.light, // Light status bar icons
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),

      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.black, // <-- SEE HERE
      //   statusBarIconBrightness:
      //       Brightness.light, //<-- For Android SEE HERE (dark icons)
      //   statusBarBrightness:
      //       Brightness.light, //<-- For iOS SEE HERE (dark icons)
      // ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.black,
    ),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryHighlight, // Cursor color
      selectionColor: AppColors.primaryHighlight.withValues(
        alpha: 0.2,
      ), // Background color when text is selected
      selectionHandleColor:
      AppColors.primaryHighlight, // Handle color (the draggable circles)
    ),
  );
}
