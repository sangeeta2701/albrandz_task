
import 'package:albrandz_task/Widgets/customThemeButton.dart';
import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';


import '../../utils/colors.dart';
import '../../utils/constants.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key, required this.mob});
  final String mob;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();
  
   

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
                    bottomRight: Radius.circular(280),
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/img4.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Profile",
                      style: blackMainHeading,
                    ),
                    height20,
                    TextFormField(),
                    
                    
                    
                    height30,
                   customThemeButton("Continue", () { })
                   
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
