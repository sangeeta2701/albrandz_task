import 'package:albrandz_task/Screens/Home/map2.dart';
import 'package:albrandz_task/Screens/Home/map3.dart';
import 'package:albrandz_task/Screens/Home/map4.dart';
import 'package:albrandz_task/Screens/Home/map5.dart';
import 'package:albrandz_task/Screens/Home/map_screen.dart';
import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

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
            bottom: 600,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(250),
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/img6.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              top: 50,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: wColor,
                    child: Icon(
                      Icons.menu,
                      color: bColor,
                    ),
                  ),
                  width20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userGreeting(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: wColor),
                      ),
                      Text(
                        "User Name",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: wColor),
                      ),
                    ],
                  )
                ],
              )),
          Positioned(
              top: 230,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: gColor,
                      ),
                      hintText: "Where to go",
                      hintStyle: blackContent,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Map5()));
                    },
                  ),
                  height24,
                  Text(
                    "Suggestions",
                    style: blackMainHeading,
                  ),
                  height8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      sugeestionOptions("assets/images/img8.png", "Ride"),
                      sugeestionOptions("assets/images/img9.png", "Rental"),
                      sugeestionOptions("assets/images/img10.png", "Reserve"),
                    ],
                  ),
                  height24,
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 1, 126, 140)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "50% off on\nReserve Rides",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: wColor),
                                ),
                                height12,
                                Text(
                                  "Reserve Now ->",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: wColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 150,
                            width: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/img11.jpg"),
                                    fit: BoxFit.fill)),
                          ),
                        ]),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget sugeestionOptions(String img, String name) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
              color: wColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gColor.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ],
              image:
                  DecorationImage(image: AssetImage(img), fit: BoxFit.contain)),
        ),
        height8,
        Text(
          name,
          style: blackContent,
        )
      ],
    );
  }
}
