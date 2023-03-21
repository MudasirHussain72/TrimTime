import 'dart:core';
import 'package:barbar_booking_app/model/user_model.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignupController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  //for getting loaction
  final latitude = '';
  final longitude = '';
  
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
    String phoneNum,
    // String latitude,
    // String longitude,
    bool isBarber,
    String password,
  ) async {
    setLoading(true);
    try {
      // ignore: unused_local_variable
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        UserModel user = UserModel(
          userName: username,
          email: value.user!.email,
          profileImage: '',
          isBarber: isBarber,
          latitude: latitude,
          longitude: longitude,
          phone: phoneNum,
          uid: value.user!.uid,
        );
        SessionController().userId = value.user!.uid.toString();
        db.collection('users').doc(user.uid).set(user.toJson());
        setLoading(false);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.dashboardView, (route) => false);
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.toastMessage(error.toString());
        //
        Utils.toastMessage("User created successfully");
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
