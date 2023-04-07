import 'package:barbar_booking_app/res/components/shop_service_display_card.dart';
import 'package:barbar_booking_app/view/customer_dashboard/book_appointment/book_appointment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChooseBookServiceBottomSheet extends StatelessWidget {
  final shopUid;
  final shopName;
  const ChooseBookServiceBottomSheet(
      {super.key, required this.shopUid, required this.shopName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 1;
    return SizedBox(
      height: size.height / 1.8,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Choose a service from $shopName to book your appoinment',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontFamily: 'DancingScript-Regular')),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(shopUid)
                .collection('services')
                .snapshots(),
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
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 40, top: 20, left: 20),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookAppointmentScreen(
                                      serviceName: doc['serviceName'],
                                      servicePrice: doc['price'],
                                      serviceUid: doc['id'],
                                      shopUid: shopUid)),
                            );
                          },
                          child: ShopServicesDisplayCard(snap: doc)),
                    );
                  },
                ));
              }
              // return Text('data');
            }),
      ]),
    );
  }
}
