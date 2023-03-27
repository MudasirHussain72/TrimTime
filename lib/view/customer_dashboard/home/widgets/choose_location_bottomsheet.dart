import 'dart:async';
import 'package:barbar_booking_app/view_model/customer_dashboard/customer_home/customer_home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ChooseLocationBottomSheet extends StatefulWidget {
  const ChooseLocationBottomSheet({super.key});

  @override
  State<ChooseLocationBottomSheet> createState() =>
      _ChooseLocationBottomSheetState();
}

class _ChooseLocationBottomSheetState extends State<ChooseLocationBottomSheet> {
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
    var provider = Provider.of<CustomerHomeController>(context, listen: false);
    getUserCurrentLocation().then((value) async {
      // ignore: await_only_futures
      final coordinates = await Coordinates(value.latitude, value.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = address.first;
      provider.setAddress(first.addressLine.toString());
      provider.setLatitude(value.latitude);
      provider.setLongitude(value.longitude);
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
      controller
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
          .then((value) => Navigator.pop(context));
      // setState(() {});
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // confirmLocation() async {
  //   await Utils.toastMessage('Location Added');
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return SizedBox(
      height: size.height / 1.5,
      child: StatefulBuilder(
          builder: (context, setState) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 110),
                        child: FloatingActionButton(
                          onPressed: () {
                            loadCurrentLocation();
                          },
                          child: const Icon(Icons.location_on),
                        ),
                      ),
                    ),
                    // Align(
                    //     alignment: Alignment.bottomRight,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(
                    //           right: 60, left: 10, bottom: 10),
                    //       child: RoundButton(
                    //         title: 'Confirm Location',
                    //         onPress: () {
                    //           confirmLocation();
                    //         },
                    //       ),
                    //     )),
                  ],
                ),
              )),
    );
  }
}
