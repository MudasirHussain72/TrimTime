import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAllBookingsInAShop extends StatefulWidget {
  final shopName;
  final shopUid;
  const MyAllBookingsInAShop(
      {super.key, required this.shopUid, required this.shopName});

  @override
  State<MyAllBookingsInAShop> createState() => _MyAllBookingsInAShopState();
}

class _MyAllBookingsInAShopState extends State<MyAllBookingsInAShop> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 1;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            //top bar
            MyAppBar(
                oniconTap: () {},
                title: 'My Bookings in ${widget.shopName}',
                icon: CupertinoIcons.calendar),
            // show all bookings in a shops
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(widget.shopUid)
                  .collection('bookings')
                  .where('userId', isEqualTo: SessionController().userId)
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
                      // return Text('data');
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: size.height * .22,
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.transparent,
                                AppColors.primaryColor
                              ]),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Service Name: ${doc['serviceName']}',
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: size.width * .055,
                                      fontFamily: 'BebasNeue-Regular')),
                              Text('Service Price: ${doc['servicePrice']}'),
                              Text(
                                  'Service Duration: ${doc['serviceDuration']}'),
                              Text('Booking Start: ${doc['bookingStart']}'),
                              Text('Booking End: ${doc['bookingEnd']}'),
                            ]),
                      );
                    },
                  ));
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
