import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/view/customer_dashboard/services/services_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ShopDisplayCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const ShopDisplayCard({
    super.key,
    required this.snap,
  });

  @override
  State<ShopDisplayCard> createState() => _ShopDisplayCardState();
}

class _ShopDisplayCardState extends State<ShopDisplayCard> {
//
  late final Future myFuture;
  double? averageShopRating;
  Future<double> _getAverageRating() async {
    // Reference to your Firestore collection
    CollectionReference ratingsCollection = FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.snap['uid'])
        .collection('rating');

    // Query to get all documents in the collection
    QuerySnapshot querySnapshot = await ratingsCollection.get();

    // Get the total number of ratings and sum of all ratings
    int totalRatings = querySnapshot.docs.length;
    double totalSum = 0.0;
    querySnapshot.docs.forEach((doc) {
      totalSum += doc['rating'];
    });

    // Calculate the average rating
    double averageRating = totalSum / totalRatings;

    setState(() {
      averageShopRating = averageRating;
    });
    print(averageShopRating);
    return averageRating;
  }

//
  @override
  void initState() {
    super.initState();
    myFuture = _getAverageRating();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: DisplayServicesScreen(
            shopAddress: widget.snap['address'],
            shopUid: widget.snap['uid'],
            shopName: widget.snap['shopName']),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.fade,
      ),
      child: Container(
        height: size.height / 2.5,
        width: size.width / 1.7,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [
            CachedNetworkImage(
              imageUrl: widget.snap['shopImage'],
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.transparent, AppColors.primaryColor]))),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 12),
                  child: Text(widget.snap['shopName'],
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: size.width * .055,
                          fontFamily: 'BebasNeue-Regular'))),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 12, right: 6),
                child: FutureBuilder(
                  future: myFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading');
                    } else {
                      return Text(
                        '${averageShopRating} ⭐',
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: size.width * .055,
                            fontFamily: 'DancingScript-Regular'),
                      );
                    }
                  },
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
