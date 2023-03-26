import 'dart:async';
import 'dart:developer';

import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/choose_location_button.dart';
import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/signup/signup_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String barberLatitude = '';
  String barberLongitude = '';
  String barberAddress = '';
  String tempLatitude = '';
  String tempLongitude = '';
  String tempAddress = '';
  final _formkey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 14.4746,
  );
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(24.8607, 67.0011),
        infoWindow: InfoWindow(title: 'The title of the marker'))
  ];
  loadCurrentLocation() {
    getUserCurrentLocation().then((value) async {
      final coordinates = await Coordinates(value.latitude, value.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = address.first;
      tempAddress = first.addressLine.toString();
      tempLatitude = value.latitude.toString();
      tempLongitude = value.longitude.toString();
      _markers.add(
        Marker(
          markerId: const MarkerId('2'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: 'My Curent Location'),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
          zoom: 16, target: LatLng(value.latitude, value.longitude));
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print('error$error');
      }
    });
    return await Geolocator.getCurrentPosition();
  }

  confirmLocation() async {
    barberAddress = tempAddress;
    barberLatitude = tempLatitude;
    barberLongitude = tempLongitude;
    setState(() {});
    await Utils.toastMessage('Location Added');
    Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
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
                            hint:
                                widget.isBarberRole ? "Shop Name" : "User Name",
                            obscureText: false,
                            onValidator: (value) {
                              return value.isEmpty ? "Enter Name" : null;
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
                              return value.isEmpty ? "Enter Email" : null;
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
                                        inputBorder: InputBorder.none,
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
                              return value.isEmpty ? "Enter Password" : null;
                            },
                          ),
                        ]),
                      ),
                    ),
                    if (widget.isBarberRole == true) ...[
                      ChooseLocationButton(
                        title: barberAddress == ''
                            ? 'Choose Location'
                            : barberAddress,
                        onPress: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SizedBox(
                                    height: size.height / 1.5,
                                    child: StatefulBuilder(
                                        builder: (context, setState) => Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Stack(
                                                children: [
                                                  GoogleMap(
                                                    initialCameraPosition:
                                                        _kGooglePlex,
                                                    markers: Set<Marker>.of(
                                                        _markers),
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) {
                                                      _controller
                                                          .complete(controller);
                                                    },
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10,
                                                              bottom: 110),
                                                      child:
                                                          FloatingActionButton(
                                                        onPressed: () {
                                                          loadCurrentLocation();
                                                        },
                                                        child: const Icon(
                                                            Icons.location_on),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 60,
                                                                left: 10,
                                                                bottom: 10),
                                                        child: RoundButton(
                                                          title:
                                                              'Confirm Location',
                                                          onPress: () {
                                                            confirmLocation();
                                                          },
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            )),
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
                              if (barberLatitude == '') {
                                Utils.toastMessage('Choose your Location');
                              }
                              if (widget.isBarberRole == true &&
                                  barberLatitude != '' &&
                                  _formkey.currentState!.validate()) {
                                provider.signUpUser(
                                  context,
                                  userNameController.text.trim().toString(),
                                  emailController.text.trim().toString(),
                                  passwordController.text.trim().toString(),
                                  phoneController.text.trim().toString(),
                                  barberLatitude,
                                  barberLongitude,
                                  barberAddress,
                                  widget.isBarberRole,
                                );
                                log(barberLatitude);
                              } else if (_formkey.currentState!.validate() &&
                                  widget.isBarberRole == false) {
                                provider.signUpUser(
                                  context,
                                  userNameController.text.trim().toString(),
                                  emailController.text.trim().toString(),
                                  passwordController.text.trim().toString(),
                                  phoneController.text.trim().toString(),
                                  '',
                                  '',
                                  barberAddress,
                                  widget.isBarberRole,
                                );
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
