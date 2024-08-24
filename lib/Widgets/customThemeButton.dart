

import 'package:albrandz_task/utils/colors.dart';
import 'package:albrandz_task/utils/constants.dart';
import 'package:flutter/material.dart';

ElevatedButton customThemeButton(String buttonText, VoidCallback ontap) {
    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      onPressed: ontap,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          buttonText,
                          style: buttonTextStyle,
                        ),
                      )));
  }