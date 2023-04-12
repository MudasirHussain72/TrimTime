import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/material.dart';

class MyShopBookingCard extends StatelessWidget {
  final snap;
  const MyShopBookingCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: size.height * .35,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.transparent, AppColors.primaryColor]),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Name: ${snap['serviceName']}',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: size.width * .055,
                    fontFamily: 'BebasNeue-Regular')),
            Text('Service Price: ${snap['servicePrice']}'),
            Text('Customer Name: ${snap['userName']}'),
            Text('Service Duration: ${snap['serviceDuration']}'),
            Text('Booking Start: ${snap['bookingStart']}'),
            Text('Booking End: ${snap['bookingEnd']}'),
            Text(
                'Booking Status: ${snap['serviceStatus'] ? 'Completed' : 'Pending'}'),
          ]),
    );
  }
}
