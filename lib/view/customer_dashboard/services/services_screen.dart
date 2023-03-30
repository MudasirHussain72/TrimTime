// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/res/components/shop_service_display_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayServicesScreen extends StatefulWidget {
  final shopName;
  final shopUid;
  const DisplayServicesScreen(
      {super.key, required this.shopUid, required this.shopName});

  @override
  State<DisplayServicesScreen> createState() => _DisplayServicesScreenState();
}

class _DisplayServicesScreenState extends State<DisplayServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Column(children: [
            MyAppBar(
                oniconTap: () {},
                title: '${widget.shopName} services',
                icon: CupertinoIcons.chat_bubble_text_fill),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.shopUid)
                    .collection('services')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 40, top: 20, left: 20),
                          child: ShopServicesDisplayCard(snap: doc),
                          // child: Text(snapshot.data!.docs.length.toString()),
                        );
                      },
                    ));
                  }
                  // return Text('data');
                }),
          ]),
        ),
      ),
    );
  }
}
