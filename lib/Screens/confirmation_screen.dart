import 'package:albrandz_task/Widgets/customThemeButton.dart';
import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';


import '../../utils/colors.dart';
import '../../utils/constants.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
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
            bottom: 380,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(250),
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/img3.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/tick.png", height: 60,width: 60,),
                  height12,
                  Text(
                    "Your Profile has been submitted successfully!",
                    style: blackContent,
                  ),
                  
                  height80,
                  customThemeButton("Next", () { 
                    
                  }),
                ],
              ))
        ],
      ),
    );
  }

  
}
