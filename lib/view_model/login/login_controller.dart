import 'dart:io';
import 'package:barbar_booking_app/res/components/show_otp_dialog.dart';
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

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result = await auth.signInWithPhoneNumber(phoneNumber);
      // Diplay Dialog Box To accept OTP
      final otpFocusNode = FocusNode();
      showOTPDialog(
        otpFocusNode: otpFocusNode,
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await auth.signInWithCredential(credential).then((value) async {
            if (await userExists()) {
              SessionController().userId = value.user!.uid.toString();
              await Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.dashboardView, (route) => false);

              await Utils.toastMessage("User login successfully");
              await setLoading(false);
            } else {
              SessionController().userId = value.user!.uid.toString();
              await firestore.doc(value.user!.uid.toString()).set({
                'uid': value.user!.uid.toString(),
                'email': '',
                'onlineStatus': 'noOne',
                'phone': value.user!.phoneNumber,
                'userName': '',
                'city': '',
                'profileImage': '',
                'userLocationLat': '',
                'userLocationLong': '',
              }).then((value) async {
                await Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.dashboardView, (route) => false);
                await Utils.toastMessage("User login successfully");
                await setLoading(false);
              }).onError((error, stackTrace) {
                setLoading(false);
                Utils.toastMessage(error.toString());
              });
            }
          });
          Navigator.of(context).pop(); // Remove the dialog box
        },
      );
    } else {
      // FOR ANDROID, IOS
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          Utils.toastMessage(e.message!.toString());
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          final otpFocusNode = FocusNode();
          showOTPDialog(
            otpFocusNode: otpFocusNode,
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );
              // !!! Works only on Android, iOS !!!
              await auth.signInWithCredential(credential).then((value) async {
                if (await userExists()) {
                  SessionController().userId = value.user!.uid.toString();
                  await Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.dashboardView, (route) => false);
                  await Utils.toastMessage("User login successfully");
                  await setLoading(false);
                } else {
                  SessionController().userId = value.user!.uid.toString();
                  await firestore.doc(value.user!.uid.toString()).set({
                    'uid': value.user!.uid.toString(),
                    'email': '',
                    'onlineStatus': 'noOne',
                    'phone': value.user!.phoneNumber,
                    'userName': '',
                    'city': '',
                    'profileImage': '',
                    'userLocationLat': '',
                    'userLocationLong': '',
                  }).then((value) async {
                    await Navigator.pushNamedAndRemoveUntil(
                        context, RouteName.dashboardView, (route) => false);
                    // Navigator.pushReplacementNamed(
                    //   context, RouteName.dashboardView,
                    //   // (route) => false
                    // );
                    await Utils.toastMessage("User login successfully");
                    await setLoading(false);
                  }).onError((error, stackTrace) {
                    setLoading(false);
                    Utils.toastMessage(error.toString());
                  });
                }
              }).onError((error, stackTrace) {
                setLoading(false);
                Utils.toastMessage(error.toString());
              });
              Navigator.of(context).pop(); // Remove the dialog box
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  //for checking user exists or not?
  static Future<bool> userExists() async {
    return (await LoginController()
            .firestore
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .exists;
  }
}
