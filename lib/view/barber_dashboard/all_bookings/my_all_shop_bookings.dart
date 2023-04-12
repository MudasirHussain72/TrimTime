import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view/barber_dashboard/all_bookings/widgets/my_shop_booking_card.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAllShopBookings extends StatefulWidget {
  const MyAllShopBookings({super.key});

  @override
  State<MyAllShopBookings> createState() => _MyAllShopBookingsState();
}

class _MyAllShopBookingsState extends State<MyAllShopBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyAppBar(
                oniconTap: () {},
                title: 'Bookings',
                icon: CupertinoIcons.calendar),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(SessionController().userId)
                    .collection('bookings')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              return InkWell(
                                onLongPress: () {
                                  if (doc['serviceStatus'] == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Have you served in this Service OR Booking?'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                    'If yes then set pending status to completed'),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .hintColor))),
                                            TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('bookings')
                                                      .doc(SessionController()
                                                          .userId)
                                                      .collection('bookings')
                                                      .doc(doc['bookingDocId'])
                                                      .update({
                                                    'serviceStatus': true,
                                                  }).then((value) {
                                                    Navigator.pop(context);
                                                    Utils.flushBarDoneMessage(
                                                        'Service completed successfully',
                                                        BuildContext,
                                                        context);
                                                  });
                                                },
                                                child: Text('Ok',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .hintColor)))
                                          ]),
                                    );
                                  } else {
                                    Utils.flushBarErrorMessage(
                                        'Cannot update Completed Booking',
                                        BuildContext,
                                        context);
                                  }
                                },
                                child: MyShopBookingCard(snap: doc),
                              );
                            }));
                  }
                })
          ],
        ),
      )),
    );
  }
}
