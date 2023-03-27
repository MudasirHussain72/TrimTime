// ignore_for_file: unused_local_variable

import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/view/barber_dashboard/dashboard_screen.dart';
import 'package:barbar_booking_app/view/customer_dashboard/dashboard_screen.dart';
import 'package:barbar_booking_app/view/forgot_password/forgot_password.dart';
import 'package:barbar_booking_app/view/login/login_screen.dart';
import 'package:barbar_booking_app/view/choose_role/choose_role_screen.dart';
import 'package:barbar_booking_app/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.loginView:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.forgotPasswordView:
        return MaterialPageRoute(builder: (_) => const ForgotPasseordScreen());
      case RouteName.chooseRoleView:
        return MaterialPageRoute(builder: (_) => const FirstScreen());
      // case RouteName.signupView:
      //   return MaterialPageRoute(builder: (_) =>   SignUpScreen(chooseRole: ,));
      case RouteName.barberdashboardView:
        return MaterialPageRoute(builder: (_) =>   const BarberDashboardScreen());
      case RouteName.customerdashboardView:
        return MaterialPageRoute(
            builder: (_) => const CustomerDashboardScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
