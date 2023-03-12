import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:flutter/material.dart';

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
  required FocusNode otpFocusNode,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title:
          Text("Enter OTP", style: Theme.of(context).textTheme.headlineSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InputTextField(
              myController: codeController,
              focusNode: otpFocusNode,
              onFieldSubmittedValue: (newValue) {},
              onValidator: (value) {
                return value.isEmpty ? "Enter otp" : null;
              },
              keyBoardType: TextInputType.number,
              hint: '000000',
              maxLength: 6,
              obscureText: false),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Done"),
        )
      ],
    ),
  );
}
