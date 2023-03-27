import 'dart:core';
import 'package:barbar_booking_app/model/user_model.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class SignupController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // status lodaing
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // sign up func
  void signUpUser(
    BuildContext context,
    String username,
    String email,
    String password,
    String phoneNum,
    String latitude,
    String longitude,
    String barberAddress,
    bool isBarber,
  ) async {
    setLoading(true);
    try {
      // ignore: unused_local_variable
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        UserModel user = UserModel(
          userName: username,
          email: value.user!.email,
          profileImage: '',
          isBarber: isBarber,
          latitude: latitude,
          longitude: longitude,
          phone: phoneNum,
          uid: value.user!.uid,
          address: barberAddress,
        );
        SessionController().userId = value.user!.uid.toString();
        SessionController().isBarber = isBarber;
        db.collection('users').doc(user.uid).set(user.toJson());
        setLoading(false);
        if (isBarber == true) {
          final geo = GeoFlutterFire();
          GeoFirePoint myLocation = geo.point(
              latitude: double.parse(latitude),
              longitude: double.parse(longitude));
          await db
              .collection('users')
              .doc(user.uid)
              .update({'name': 'random name', 'position': myLocation.data});
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.barberdashboardView, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.customerdashboardView, (route) => false);
        }

        await Utils.toastMessage("Account created successfully");
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.toastMessage(error.toString());
        //
        setLoading(false);
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.toastMessage(error.toString());
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage(e.toString());
    }
  }

  @override
  notifyListeners();
}
