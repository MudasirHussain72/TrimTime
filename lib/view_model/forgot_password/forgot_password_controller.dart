import 'package:barbar_booking_app/utils/routes/route_name.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

// forgotPassword
  void forgotPassword(BuildContext context, String email) async {
    setLoading(true);
    try {
      // ignore: unused_local_variable
      final user =
          await auth.sendPasswordResetEmail(email: email).then((value) {
        setLoading(false);
        Navigator.pushNamed(context, RouteName.loginView);
        Utils.toastMessage("Please check your email to recover your account");
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
}
