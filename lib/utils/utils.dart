import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';

class Utils {
  static void fieldFocus(
    BuildContext context,
    FocusNode currentNode,
    FocusNode nextFocus,
  ) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: AppColors.secondaryColor,
        textColor: AppColors.whiteColor,
        fontSize: 16);
  }

  static void flushBarDoneMessage(String message, BuildContext, context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          message: message,
          forwardAnimationCurve: Curves.easeIn,
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(15),
          duration: Duration(seconds: 3),
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.green.shade400,
          positionOffset: 20,
          icon: Icon(
            Icons.done_rounded,
            size: 20,
            color: Colors.white,
          ),
        )..show(context));
  }

  static void flushBarErrorMessage(String message, BuildContext, context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          message: message,
          forwardAnimationCurve: Curves.easeIn,
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(15),
          duration: Duration(seconds: 3),
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.red.shade400,
          positionOffset: 20,
          icon: Icon(
            Icons.error,
            size: 20,
            color: Colors.white,
          ),
        )..show(context));
  }
}
