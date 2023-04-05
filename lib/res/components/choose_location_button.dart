import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/material.dart';

class ChooseLocationButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool loading;
  final Color iconColor;
  const ChooseLocationButton({
    super.key,
    required this.title,
    required this.onPress,
    this.loading = false,
    this.iconColor = AppColors.primaryIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        // height: ,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.textFieldDefaultBorderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.location_on_rounded,
            color: iconColor,
          )
        ]),
      ),
    );
  }
}
