import 'dart:async';

import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mob});
  final String mob;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int secondsRemaining = 60;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });
  }
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();
   final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    textStyle: TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(10, 31, 50, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: gColor.withOpacity(0.3)),
    ),
  );

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
                      image: AssetImage("assets/images/img3.jpg"),
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
                      "Verify",
                      style: blackMainHeading,
                    ),
                    height20,
                    Text(
                      "Enter the 6-digit OTP sent to you at ${widget.mob}",
                      style: blackContent,
                    ),
                    height12,
                     Align(
                            alignment: Alignment.center,
                            child: Pinput(
                              length: 6,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: pinController,
                              focusNode: focusNode,
                              androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.smsUserConsentApi,
                              listenForMultipleSmsOnAndroid: true,
                              defaultPinTheme: defaultPinTheme,
                              hapticFeedbackType: HapticFeedbackType.heavyImpact,
                              onCompleted: (pin) {
                                debugPrint('onCompleted: $pin');
                                if (_formKey.currentState!.validate()) {
                                 
                                }
                              },
                              onChanged: (value) {
                                debugPrint('onChanged: $value');
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter email";
                                } else {
                                  return null;
                                }
                              },
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 9),
                                    width: 22,
                                    height: 1,
                                    color: Colors.purple,
                                  ),
                                ],
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          
                    
                    height30,
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: bColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onPressed: () {},
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Continue",
                            style: buttonText,
                          ),
                        ))),
                    height12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Resend OTP  ",
                          style: blackContent,
                        ),
                        Text("($secondsRemaining seconds)")
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
