import 'dart:async';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null || SessionController().isBarber == true) {
      SessionController().userId = user!.uid.toString();
      SessionController().isBarber = true;
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.barberdashboardView, (route) => false));
    }
    if (user != null || SessionController().isBarber == false) {
      SessionController().userId = user!.uid.toString();
      SessionController().isBarber = false;
      SessionController().latitude = 33.6844;
      SessionController().longitude = 73.0479;
      SessionController().addressLine = 'Islamabad Capital of Pakistan';
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.customerdashboardView, (route) => false));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.loginView, (route) => false));
    }
  }
}
