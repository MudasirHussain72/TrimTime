import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
}
