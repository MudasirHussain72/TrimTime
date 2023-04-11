import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookingDetailCard extends StatelessWidget {
  final snap;
  final shopUid;
  const BookingDetailCard(
      {super.key, required this.snap, required this.shopUid});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 1;
    return InkWell(
      onTap: () {
        if (snap['serviceStatus'] == true) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(children: [
              Center(
                  child: Text('Rate service now',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontFamily: 'DancingScript-Regular'))),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        // rate this service function
                        FirebaseFirestore.instance
                            .collection('shops')
                            .doc(shopUid)
                            .update({});
                      },
                      child: Text('Done'))
                ],
              )
            ]),
          );
        } else {
          Utils.flushBarErrorMessage(
              'Cannot rate pending service', BuildContext, context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: size.height * .3,
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
              Text('Service Duration: ${snap['serviceDuration']}'),
              Text('Booking Start: ${snap['bookingStart']}'),
              Text('Booking End: ${snap['bookingEnd']}'),
              Text(
                  'Service Status: ${snap['serviceStatus'] ? 'Completed' : 'Pending'}'),
            ]),
      ),
    );
  }
}
