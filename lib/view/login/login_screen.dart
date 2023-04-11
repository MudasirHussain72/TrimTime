import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * .01),
                  Text("Welcome to",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: size.height * .002),
                  Center(
                      child: Image(
                    image: const AssetImage('assets/images/logo.png'),
                    width: size.width / 2,
                  )),
                  SizedBox(height: size.height * .04),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign in to Continue",
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
                          myController: emailController,
                          focusNode: emailFocusNode,
                          onFieldSubmittedValue: (newValue) {
                            Utils.fieldFocus(
                                context, emailFocusNode, passwordFocusNode);
                          },
                          keyBoardType: TextInputType.emailAddress,
                          hint: "Email",
                          obscureText: false,
                          onValidator: (value) {
                            return value.isEmpty ? "Enter email" : null;
                          },
                        ),
                        SizedBox(height: size.height * .01),
                        InputTextField(
                          myController: passwordController,
                          focusNode: passwordFocusNode,
                          onFieldSubmittedValue: (newValue) {},
                          keyBoardType: TextInputType.emailAddress,
                          hint: "Password",
                          obscureText: false,
                          onValidator: (value) {
                            return value.isEmpty ? "enter password" : null;
                          },
                        ),
                      ]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, RouteName.forgotPasswordView),
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 15, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .04),
                  ChangeNotifierProvider(
                    create: (context) => LoginController(),
                    child: Consumer<LoginController>(
                      builder: (context, provider, child) => RoundButton(
                        loading: provider.loading,
                        title: "Login",
                        onPress: () {
                          if (_formkey.currentState!.validate()) {
                            provider.login(
                                context,
                                emailController.text.trim().toString(),
                                passwordController.text.trim().toString());
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.chooseRoleView);
                    },
                    child: Text.rich(
                      TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                            )
                          ]),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
