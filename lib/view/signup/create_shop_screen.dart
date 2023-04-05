import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/choose_location_button.dart';
import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/res/components/set_availability_button.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/signup/create_shop_controller.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  String barberLatitude = '';
  String barberLongitude = '';
  String tempLatitude = '';
  String tempLongitude = '';
  String tempAddress = '';
  String barberAddress = '';
  File? imageFile;
  getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  final _formkey = GlobalKey<FormState>();
  final shopController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();
  final shopNameFocusNode = FocusNode();
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
      // ignore: await_only_futures
      final coordinates = await Coordinates(value.latitude, value.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = address.first;
      tempAddress = first.addressLine.toString();
      tempLatitude = value.latitude.toString();
      tempLongitude = value.longitude.toString();
      _markers.add(
        await Marker(
          markerId: const MarkerId('2'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: 'My Curent Location'),
        ),
      );
      CameraPosition cameraPosition = await CameraPosition(
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
      log('error$error');
    });
    return await Geolocator.getCurrentPosition();
  }

  confirmLocation() async {
    barberAddress = tempAddress;
    barberLatitude = tempLatitude;
    barberLongitude = tempLongitude;
    setState(() {});
    await Utils.toastMessage('Location Added');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Time _fromtime = Time(hour: 8, minute: 00, second: 20);
  Time _totime = Time(hour: 20, minute: 00, second: 20);
  bool iosStyle = true;

  void fromTimeChanged(Time newTime) {
    setState(() {
      _fromtime = newTime;
    });
    log("[debug datetime]:  $_fromtime");
  }

  void toTimeChanged(Time newTime) {
    setState(() {
      _totime = newTime;
    });
    log("[debug datetime]:  $newTime");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: SingleChildScrollView(
                    child: Form(
                        key: _formkey,
                        child: Column(children: [
                          SizedBox(height: size.height * .02),
                          Text("Create your Shop",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      fontFamily: 'DancingScript-Regular')),
                          SizedBox(height: size.height * .02),
                          InputTextField(
                            myController: shopController,
                            focusNode: shopNameFocusNode,
                            onFieldSubmittedValue: (newValue) {
                              Utils.fieldFocus(context, shopNameFocusNode,
                                  phoneNumberFocusNode);
                            },
                            keyBoardType: TextInputType.name,
                            hint: "Shop Name",
                            obscureText: false,
                            onValidator: (value) {
                              return value.isEmpty ? "Enter Name" : null;
                            },
                          ),
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
                                    color: Colors.black.withOpacity(0.13))),
                            child: Stack(
                              children: [
                                InternationalPhoneNumberInput(
                                  focusNode: phoneNumberFocusNode,
                                  onInputChanged: (value) {
                                    setState(() {
                                      phoneController.text =
                                          value.phoneNumber.toString();
                                    });
                                  },
                                  countries: ['PK'],
                                  formatInput: false,
                                  inputBorder: InputBorder.none,
                                  selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * .01),
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
                                            builder: (context, setState) =>
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
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
                                                          _controller.complete(
                                                              controller);
                                                        },
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10,
                                                                  bottom: 110),
                                                          child:
                                                              FloatingActionButton(
                                                            onPressed: () {
                                                              loadCurrentLocation();
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .location_on),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .bottomRight,
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
                          ),
                          SizedBox(height: size.height * .02),
                          Text("Select time to set your availability",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2),
                          SizedBox(height: size.height * .02),
                          SetAvailability(
                            fromTimeOnTap: () {
                              Navigator.of(context).push(
                                showPicker(
                                  iosStylePicker: true,
                                  elevation: 1,
                                  context: context,
                                  value: _fromtime,
                                  onChange: fromTimeChanged,
                                ),
                              );
                            },
                            toTimeOnTap: () {
                              Navigator.of(context).push(
                                showPicker(
                                  iosStylePicker: true,
                                  elevation: 1,
                                  context: context,
                                  value: _totime,
                                  onChange: toTimeChanged,
                                ),
                              );
                            },
                            fromTime: _fromtime.format(context).toString(),
                            toTime: _totime.format(context).toString(),
                          ),
                          SizedBox(height: size.height * .04),
                          ChangeNotifierProvider(
                              create: (context) => CreateShopController(),
                              child: Consumer<CreateShopController>(
                                  builder: (context, provider, child) =>
                                      RoundButton(
                                          title: "Create Shop",
                                          loading: provider.loading,
                                          onPress: () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              provider.createShop(
                                                  context,
                                                  shopController.text
                                                      .trim()
                                                      .toString(),
                                                  phoneController.text
                                                      .toString(),
                                                  barberLatitude,
                                                  barberLongitude,
                                                  barberAddress,
                                                  _fromtime
                                                      .format(context)
                                                      .toString(),
                                                  _totime
                                                      .format(context)
                                                      .toString());
                                            }
                                          })))
                        ]))))));
  }
}
