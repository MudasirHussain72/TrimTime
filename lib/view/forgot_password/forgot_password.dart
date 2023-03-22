import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/view_model/forgot_password/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasseordScreen extends StatefulWidget {
  const ForgotPasseordScreen({super.key});

  @override
  State<ForgotPasseordScreen> createState() => _ForgotPasseordScreenState();
}

class _ForgotPasseordScreenState extends State<ForgotPasseordScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController forgotPasswordController = TextEditingController();
  final forgotPasswordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    forgotPasswordController.dispose();
    forgotPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Forgot Password"),
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * .01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Forgot\nPassword ?",
                        style: Theme.of(context).textTheme.headline3),
                  ),
                  SizedBox(height: size.height * .01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Dont't worry! it happens. Please enter the address associated with your account.",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  SizedBox(height: size.height * .01),
                  Form(
                    key: _formkey,
                    child: InputTextField(
                        myController: forgotPasswordController,
                        focusNode: forgotPasswordFocusNode,
                        onFieldSubmittedValue: (newValue) {},
                        onValidator: (value) {
                          return value.isEmpty ? "Enter email" : null;
                        },
                        keyBoardType: TextInputType.emailAddress,
                        hint: "Enter email",
                        obscureText: false),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ChangeNotifierProvider(
                  create: (context) => ForgotPasswordController(),
                  child: Consumer<ForgotPasswordController>(
                    builder: (context, provider, child) => RoundButton(
                      loading: provider.loading,
                      title: "Reset",
                      onPress: () {
                        if (_formkey.currentState!.validate()) {
                          provider.forgotPassword(
                            context,
                            forgotPasswordController.text.trim().toString(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
