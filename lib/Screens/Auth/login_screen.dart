import 'package:albrandz_task/Screens/Auth/otp_screen.dart';
import 'package:albrandz_task/Widgets/customThemeButton.dart';
import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import '../../Widgets/dialogs/progressbar.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String countryCode = "+91";
  

  Future<void> _loginUser() async {
    const apiUrl = "https://cba.albrandz.in/cba/api/passenger/login/otp";
    Map<String, dynamic> body = {
      "mobile": countryCode + numberController.text,
    };
    ProgressDialog pds =
        progresssbar(context, "Requesting...", "Please wait.....", true);

    pds.show();
    final response = await http.post(Uri.parse(apiUrl), body: body);
    print(response.body);
    print(response.statusCode);
    pds.dismiss();

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously

      Future.delayed(Duration(seconds: 3), () {
        Fluttertoast.showToast(msg: "OTP sent successfully");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(mob: body['mobile']),
          ),
        );
      });
    } else {
      pds.dismiss();
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
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
                      image: AssetImage("assets/images/img5.jpg"),
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
                      "Login",
                      style: blackMainHeading,
                    ),
                    height20,
                    Text(
                      "Enter your mobile number",
                      style: blackContent,
                    ),
                    height8,
                    IntlPhoneField(
                      validator: (value) {
                        if (value == null) {
                          return "Please Enter Your Mobile Number";
                        } else {
                          return null;
                        }
                      },
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      disableLengthCheck: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                      flagsButtonPadding: const EdgeInsets.only(left: 8),
                      dropdownIconPosition: IconPosition.trailing,
                      decoration: const InputDecoration(
                        hintText: "Enter Mobile Number",

                        // labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    height30,
                    customThemeButton("Continue", () {
                      if (_formKey.currentState!.validate()) {
                        _loginUser();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter required Field");
                      }
                    }),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
