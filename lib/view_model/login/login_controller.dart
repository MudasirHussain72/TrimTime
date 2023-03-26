import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

// email login
  void login(BuildContext context, String email, String password) async {
    setLoading(true);
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        SessionController().userId = value.user!.uid.toString();
        setLoading(false);
        route(context);
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

  // route checking
  void route(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('isBarber') == true) {
          SessionController().isBarber = true;
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.barberdashboardView, (route) => false);
          Utils.toastMessage("login successfully");
        } else {
          SessionController().isBarber = false;
          SessionController().latitude = 33.6844;
          SessionController().longitude = 73.0479;
          SessionController().addressLine = 'Islamabad Capital of Pakistan';
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.customerdashboardView, (route) => false);
          Utils.toastMessage("login successfully");
        }
      } else {
        if (kDebugMode) {
          print('Document does not exist on the database');
        }
      }
    });
  }
}
