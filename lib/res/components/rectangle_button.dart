import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  const RectangleButton(
      {super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
          height: 45,
          width: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green.shade100),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: AppColors.primaryIconColor,
                ),
                const SizedBox(width: 2),
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.primaryTextTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ])),
    );
  }
}
