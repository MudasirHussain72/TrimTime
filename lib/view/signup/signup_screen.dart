import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  bool isBarberRole;
  SignUpScreen({super.key, required this.isBarberRole});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final barBerLatitude = '';
  final barBerLongitude = '';
  final _formkey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Image(
                      image: const AssetImage('assets/images/logo.jpg'),
                      width: size.width / 2,
                    )),
                    SizedBox(height: size.height * .004),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Register your account",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Form(
                      key: _formkey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: size.height * .02, bottom: size.height * .01),
                        child: Column(children: [
                          InputTextField(
                            myController: userNameController,
                            focusNode: userNameFocusNode,
                            onFieldSubmittedValue: (newValue) {
                              Utils.fieldFocus(
                                  context, userNameFocusNode, emailFocusNode);
                            },
                            keyBoardType: TextInputType.name,
                            hint: "User Name",
                            obscureText: false,
                            onValidator: (value) {
                              return value.isEmpty ? "enter Name" : null;
                            },
                          ),
                          SizedBox(height: size.height * .01),
                          InputTextField(
                            myController: emailController,
                            focusNode: emailFocusNode,
                            onFieldSubmittedValue: (newValue) {
                              Utils.fieldFocus(context, emailFocusNode,
                                  phoneNumberFocusNode);
                            },
                            keyBoardType: TextInputType.emailAddress,
                            hint: "Email",
                            obscureText: false,
                            onValidator: (value) {
                              return value.isEmpty ? "enter email" : null;
                            },
                          ),
                          SizedBox(height: size.height * .01),
                          if (widget.isBarberRole == true) ...[
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xffeeeeee),
                                            blurRadius: 10,
                                            offset: Offset(0, 4))
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                              Colors.black.withOpacity(0.13))),
                                  child: Stack(
                                    children: [
                                      InternationalPhoneNumberInput(
                                        focusNode: phoneNumberFocusNode,
                                        onFieldSubmitted: (value) {
                                          Utils.fieldFocus(
                                              context,
                                              phoneNumberFocusNode,
                                              passwordFocusNode);
                                        },
                                        onInputChanged: (value) {
                                          setState(() {
                                            phoneController.text =
                                                value.phoneNumber.toString();
                                          });
                                        },
                                        formatInput: false,
                                        selectorConfig: const SelectorConfig(
                                            selectorType: PhoneInputSelectorType
                                                .BOTTOM_SHEET),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                          SizedBox(height: size.height * .01),
                          InputTextField(
                            myController: passwordController,
                            focusNode: passwordFocusNode,
                            onFieldSubmittedValue: (newValue) {},
                            keyBoardType: TextInputType.emailAddress,
                            hint: "Password",
                            obscureText: true,
                            onValidator: (value) {
                              return value.isEmpty ? "enter password" : null;
                            },
                          ),
                        ]),
                      ),
                    ),
                    if (widget.isBarberRole == true) ...[
                      RoundButton(
                        color: AppColors.lightGrayColor,
                        title: "Choose your Location",
                        // loading: provider.loading,
                        onPress: () {},
                      )
                    ],
                    SizedBox(height: size.height * .04),
                    ChangeNotifierProvider(
                        create: (context) => SignupController(),
                        child: Consumer<SignupController>(
                          builder: (context, provider, child) => RoundButton(
                            title: "SignUp",
                            loading: provider.loading,
                            onPress: () {
                              // if (SignupController().latitude == '') {
                              //   Utils.toastMessage('Choose your Location');
                              // }
                              //  else
                              if (_formkey.currentState!.validate()) {
                                provider.signUpUser(
                                    context,
                                    userNameController.text.trim().toString(),
                                    emailController.text.trim().toString(),
                                    phoneController.text.trim().toString(),
                                    widget.isBarberRole,
                                    passwordController.text.trim().toString());
                              }
                            },
                          ),
                        )),
                    SizedBox(height: size.height * .03),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.loginView);
                      },
                      child: Text.rich(
                        TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontSize: 15),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                              )
                            ]),
                      ),
                    )
                  ]),
            )),
      ),
    );
  }
}
