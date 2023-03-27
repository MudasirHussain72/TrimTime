import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/res/components/shop_display_card.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BarberHomeScreen extends StatefulWidget {
  const BarberHomeScreen({super.key});

  @override
  State<BarberHomeScreen> createState() => _BarberHomeScreenState();
}

class _BarberHomeScreenState extends State<BarberHomeScreen> {
  final stream = FirebaseFirestore.instance
      .collection('users')
      .doc(SessionController().userId)
      .collection('services')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        // my app bar custom component widget
        AppBar(elevation: 0),
        MyAppBar(
            oniconTap: () {},
            title: 'Your Offering these services',
            icon: Icons.add),
        StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: 40, top: 20, left: 20),
                    child: ShopDisplayCard(snap: snapshot.data!.docs[index]),
                  ),
                ));
              }
            }
            // return Text('data');
            ),
      ]),
    );
  }
}
