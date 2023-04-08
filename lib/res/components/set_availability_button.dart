import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/material.dart';

class SetAvailability extends StatelessWidget {
  String fromTime;
  String toTime;
  VoidCallback fromTimeOnTap;
  VoidCallback toTimeOnTap;
  SetAvailability(
      {super.key,
      required this.fromTime,
      required this.toTime,
      required this.fromTimeOnTap,
      required this.toTimeOnTap});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      InkWell(
        onTap: fromTimeOnTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          width: size.width / 2.5,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.textFieldDefaultBorderColor),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(fromTime), const Icon(Icons.access_time_rounded)],
          ),
        ),
      ),
      Text('To',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      InkWell(
        onTap: toTimeOnTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          width: size.width / 2.5,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.textFieldDefaultBorderColor),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(toTime), const Icon(Icons.access_time_rounded)],
          ),
        ),
      )
    ]);
  }
}
