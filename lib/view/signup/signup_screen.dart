import 'dart:convert';
import 'dart:developer';
import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/choose_location_button.dart';
import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  bool isBarberRole;
  SignUpScreen({super.key, required this.isBarberRole});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? barBerLatitude;
  String? barBerLongitude;
  final _formkey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final placesController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> placesList = [];
  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    placesController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(placesController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = 'AIzaSyBEHLsPAwfrJ6Snn9ar4Ad7zCE1PxG_DfM';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    if (response.statusCode == 200) {
      setState(() {
        placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    placesController.dispose();
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
                      ChooseLocationButton(
                        title: 'Choose Location',
                        onPress: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              backgroundColor: AppColors.whiteColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SizedBox(
                                    height: size.height / 1.5,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text('Enter your address',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextField(
                                            decoration: const InputDecoration(
                                                hintText: 'Search address'),
                                            autofocus: true,
                                            controller: placesController,
                                          ),
                                          Expanded(
                                              child: ListView.builder(
                                            itemCount: placesList.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () async {
                                                  List<Location> locations =
                                                      await locationFromAddress(
                                                          placesList[index]
                                                              ['description']);
                                                  log(locations.last.latitude
                                                      .toString());
                                                  log(locations.last.longitude
                                                      .toString());
                                                  placesController.text =
                                                      placesList[index]
                                                          ['description'];
                                                },
                                                title: Text(placesList[index]
                                                    ['description']),
                                              );
                                            },
                                          )),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
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
                              if (widget.isBarberRole == true &&
                                  barBerLatitude!.isNotEmpty &&
                                  _formkey.currentState!.validate()) {
                                provider.signUpUser(
                                  context,
                                  userNameController.text.trim().toString(),
                                  emailController.text.trim().toString(),
                                  passwordController.text.trim().toString(),
                                  phoneController.text.trim().toString(),
                                  barBerLatitude!,
                                  barBerLongitude!,
                                  widget.isBarberRole,
                                );
                              } else if (_formkey.currentState!.validate() &&
                                  widget.isBarberRole == false) {
                                provider.signUpUser(
                                  context,
                                  userNameController.text.trim().toString(),
                                  emailController.text.trim().toString(),
                                  passwordController.text.trim().toString(),
                                  phoneController.text.trim().toString(),
                                  // barBerLatitude!,
                                  // barBerLongitude!,
                                  '000000',
                                  '000000',
                                  widget.isBarberRole,
                                );
                              } else {
                                Utils.toastMessage('Choose your Location');
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
//   AIzaSyBEHLsPAwfrJ6Snn9ar4Ad7zCE1PxG_DfM