import 'package:barbar_booking_app/res/components/shop_display_card.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class NearbyData extends StatefulWidget {
  const NearbyData({super.key});

  @override
  State<NearbyData> createState() => _NearbyDataState();
}

class _NearbyDataState extends State<NearbyData> {
  // double latitude = 33.6844;
  // double longitude = 73.0479;
  final geo = GeoFlutterFire();
  final firestore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    GeoFirePoint center = geo.point(
        latitude: double.parse(SessionController().latitude.toString()),
        longitude: double.parse(SessionController().longitude.toString()));
    firestore.where("isBarber", isEqualTo: true);
    double radius = 5000;
    String field = 'position';
    Stream<List<DocumentSnapshot>> streamNearBy = geo
        .collection(collectionRef: firestore)
        .within(center: center, radius: radius, field: field);
    return StreamBuilder(
      stream: streamNearBy,
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Expanded(
              child: ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20, left: 20),
              child: ShopDisplayCard(snap: snapshot.data![index]),
            ),
          ));
          // return Text('data');
        }
      },
    );
  }
}
