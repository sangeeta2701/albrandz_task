import 'dart:async';

import 'package:albrandz_task/Screens/Profile/create_profile_screen.dart';
import 'package:albrandz_task/Widgets/customThemeButton.dart';
import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import '../../Widgets/dialogs/progressbar.dart';
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

  Future<void> _otpVerify() async {
    const apiUrl = "https://cba.albrandz.in/cba/api/passenger/verify/otp";
    Map<String, dynamic> body = {
      "mobile": widget.mob,
      "otp": pinController.text
    };
    ProgressDialog pds =
        progresssbar(context, "Requesting...", "Please wait.....", true);

    pds.show();
    final response = await http.post(Uri.parse(apiUrl), body: body,
     headers: {
      'Content-Type': 'application/json',

    });
    print(response.body);
    print(response.statusCode);
    pds.dismiss();

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously

      Future.delayed(Duration(seconds: 3), () {
        Fluttertoast.showToast(msg: "OTP verified successfully");
        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateProfileScreen(mob: widget.mob)));
      });
    } else {
      pds.dismiss();
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  String rn = "";

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    textStyle: blackContent,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: themeColor),
    ),
  );

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    timer.cancel();
    super.dispose();
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
            bottom: 360,
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
                      "Verify",
                      style: blackMainHeading,
                    ),
                    height20,
                    Text(
                      "Enter the 6-digit OTP sent to you at ${widget.mob}",
                      style: blackContent,
                    ),
                    height12,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: Pinput(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your OTP";
                              } else {
                                return null;
                              }
                            },
                            length: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: pinController,
                            focusNode: focusNode,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            listenForMultipleSmsOnAndroid: true,
                            defaultPinTheme: defaultPinTheme,
                            // hapticFeedbackType: HapticFeedbackType.heavyImpact,

                            onChanged: (value) {
                              debugPrint('onChanged: $value');
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: gColor,
                                ),
                              ],
                            ),

                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Pinput(
                    //     length: 6,
                    //     keyboardType: TextInputType.number,
                    //     inputFormatters: [
                    //       FilteringTextInputFormatter.digitsOnly,
                    //     ],
                    //     controller: pinController,
                    //     focusNode: focusNode,
                    //     androidSmsAutofillMethod:
                    //         AndroidSmsAutofillMethod.smsUserConsentApi,
                    //     listenForMultipleSmsOnAndroid: true,
                    //     defaultPinTheme: defaultPinTheme,
                    //     hapticFeedbackType: HapticFeedbackType.heavyImpact,
                    //     onCompleted: (pin) {
                    //       debugPrint('onCompleted: $pin');
                    //       if (_formKey.currentState!.validate()) {}
                    //     },
                    //     onChanged: (value) {
                    //       debugPrint('onChanged: $value');
                    //     },
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return "Please Enter otp";
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     cursor: Column(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: [
                    //         Container(
                    //           margin: const EdgeInsets.only(bottom: 9),
                    //           width: 22,
                    //           height: 1,
                    //           color: Colors.purple,
                    //         ),
                    //       ],
                    //     ),
                    //     errorPinTheme: defaultPinTheme.copyBorderWith(
                    //       border: Border.all(color: Colors.redAccent),
                    //     ),
                    //   ),
                    // ),
                    height30,
                    customThemeButton("Continue", () {
                      if (_formKey.currentState!.validate()) {
                        _otpVerify();
                      }
                    }),
                    height12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        secondsRemaining > 0
                            ? Text(
                                "Resend OTP ",
                                style: greyTextStyle,
                              )
                            : TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Resend OTP ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: themeColor),
                                ),
                              ),
                        Text(
                          "after $secondsRemaining seconds",
                          style: greyTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
