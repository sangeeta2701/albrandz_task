import 'dart:convert';

import 'package:albrandz_task/Screens/Auth/login_screen.dart';
import 'package:albrandz_task/Widgets/customThemeButton.dart';
import 'package:albrandz_task/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 180,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(320),
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/img1.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              left: 20,
              bottom: 250,
              child: Text(
                "Cabo\nCab",
                style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: wColor,
                    height: 0.9),
              )),
          Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: customThemeButton("Let's get rides ->", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }))
        ],
      ),
    );
  }
}
