import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/view/customer_dashboard/my_bookings/my_bookings_in_shop.dart';
import 'package:barbar_booking_app/view/customer_dashboard/my_bookings/widgets/shop_booking_card.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            //top bar
            MyAppBar(
                oniconTap: () {},
                title: 'My Bookings by shops',
                icon: CupertinoIcons.calendar),
            // show bookings in all shops area
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('bookings').where(
                  'bookings',
                  arrayContainsAny: [SessionController().userId]).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return ShopBookingCard(
                          oniconTap: () =>
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: MyAllBookingsInAShop(
                                      shopName: doc['shopName'],
                                      shopUid: doc['shopUid']),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade),
                          shopAddress: doc['shopAddress'],
                          shopName: doc['shopName'],
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
