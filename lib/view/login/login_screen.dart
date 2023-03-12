// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/phone';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Continue with Phone"),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 20,
          ),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: size.height * .01),
                Center(
                    child: Image(
                  image: const AssetImage('assets/images/logo.jpg'),
                  width: size.width / 2,
                )),
                SizedBox(height: size.height * .04),
                Text("You'll recieve a 6 digit code\nto verify next.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: size.height * .02),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xffeeeeee),
                            blurRadius: 10,
                            offset: Offset(0, 4))
                      ],
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.black.withOpacity(0.13))),
                  child: Stack(
                    children: [
                      InternationalPhoneNumberInput(
                        onInputChanged: (value) {
                          setState(() {
                            phoneController.text = value.phoneNumber.toString();
                          });
                        },
                        formatInput: false,
                        selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: RoundButton(
                    loading: LoginController().loading,
                    title: "Request OTP",
                    onPress: () {
                      if (phoneController.text.toString() != null &&
                          phoneController.text.length > 11) {
                        log(phoneController.toString());
                        LoginController()
                            .phoneSignIn(context, phoneController.text);
                      } else {
                        Utils.toastMessage(
                            'Please provide correct phone number');
                      }
                    }))
          ]),
        ),
      ),
    );
  }
}
