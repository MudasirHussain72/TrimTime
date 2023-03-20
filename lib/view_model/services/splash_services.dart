import 'dart:async';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      SessionController().userId = user.uid.toString();
      Timer(
          const Duration(seconds: 2),
          // () => Navigator.pushReplacementNamed(context, RouteName.dashboardView),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.dashboardView, (route) => false));
    } else {
      Timer(
          const Duration(seconds: 2),
          // () => Navigator.pushReplacementNamed(context, RouteName.loginView),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.loginView, (route) => false));
    }
  }
}
