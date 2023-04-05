import 'dart:async';
import 'package:barbar_booking_app/api/apis.dart';
import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();
    final bool? isBarber = prefs.getBool('isBarber');
    final user = auth.currentUser;

    if (user != null && isBarber == true) {
      SessionController().userId = user.uid.toString();
      await prefs.setBool('isBarber', true);
      // Timer(
      //     const Duration(seconds: 2),
      //     () => Navigator.pushNamedAndRemoveUntil(
      //         context, RouteName.barberdashboardView, (route) => false));
      if (await APIs.shopExists()) {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushNamedAndRemoveUntil(
                context, RouteName.barberdashboardView, (route) => false));
      } else {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushNamedAndRemoveUntil(
                context, RouteName.createShopView, (route) => false));
      }
    } else if (user != null && isBarber == false) {
      SessionController().userId = user.uid.toString();
      await prefs.setBool('isBarber', false);
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
