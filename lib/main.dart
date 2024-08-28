import 'package:albrandz_task/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
             
              primaryColor: themeColor,
              primarySwatch: Colors.blue,
              inputDecorationTheme: InputDecorationTheme(
                  prefixIconColor: gColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: gColor.withOpacity(0.3), width: 1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: gColor.withOpacity(0.3), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeColor, width: 1)))),
    );
  }
}

