import 'package:albrandz_task/Screens/confirmation_screen.dart';
import 'package:albrandz_task/Widgets/customThemeButton.dart';
import 'package:albrandz_task/Widgets/sizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key, required this.mob});
  final String mob;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  String dateis = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  String geenderValue = 'Male';

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
    'Others',
  ];
  bool checkVal = false;

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
                      image: AssetImage("assets/images/img2.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              bottom: 30,
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
                    Text(
                      "Enter Full Name",
                      style: greyTextStyle,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[a-zA-Z]+|\s'),
                            allow: true)
                      ],
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: gColor,
                      )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Your Name";
                        } else if (value.length < 3) {
                          return "Atleast 3 letters required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    height12,
                    Text(
                      "Email ID",
                      style: greyTextStyle,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                        Icons.email_outlined,
                        color: gColor,
                      )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter email";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "Enter Correct email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    height12,
                    TextFormField(
                      enabled: false,
                      // controller: emailController,
                      decoration: InputDecoration(
                          hintText: widget.mob,
                          hintStyle: greyTextStyle,
                          prefixIcon: Icon(
                            Icons.call_outlined,
                            color: gColor,
                          )),
                    ),
                    height12,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date of birth",
                                style: greyTextStyle,
                              ),
                              TextFormField(
                                controller: dobController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: gColor,
                                )),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: themeColor,
                                            onPrimary: wColor,
                                            onSurface: themeColor,
                                          ),
                                        ),
                                        child: SizedBox(
                                            height: 300,
                                            width: 350,
                                            child: child!),
                                      );
                                    },
                                    initialDate: DateTime(1950),
                                    firstDate: DateTime(1950, 1, 1),
                                    lastDate: DateTime(2016, 12, 31),
                                  );
                                  if (pickedDate != null) {
                                    dateis = DateFormat("yyyy-MM-dd")
                                        .format(pickedDate);

                                    setState(() {
                                      dobController.text = dateis;
                                    });
                                  } else {}
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Date of Birth";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        width20,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: greyTextStyle,
                              ),
                              Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: gColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      // Initial Value
                                      value: geenderValue,

                                      icon: Align(
                                          alignment: Alignment.centerRight,
                                          child: const Icon(
                                              Icons.keyboard_arrow_down)),

                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: blackContent,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          geenderValue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    height12,
                    Text(
                      "PIN(6 Digit)",
                      style: greyTextStyle,
                    ),
                    TextFormField(
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: gColor,
                      )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter PIN";
                        } else {
                          return null;
                        }
                      },
                    ),
                    height12,
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: checkVal,
                      onChanged: (bool? value) {
                        setState(() {
                          checkVal = value!;
                        });
                      },
                      title: Text(
                        "I have reviewed and agree to the Terms of Use and acknowledge the Privacy Policy.",
                        style: greyTextStyle,
                      ),
                    ),
                    height30,
                    customThemeButton("Continue", () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmationScreen()));
                      // if (_formKey.currentState!.validate()) {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ConfirmationScreen()));
                      // }
                    })
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
