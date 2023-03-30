import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/view/customer_dashboard/services/services_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ShopDisplayCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const ShopDisplayCard({
    super.key,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: DisplayServicesScreen(
            shopUid: snap['uid'], shopName: snap['userName']),
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
              imageUrl: snap['profileImage'],
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
                  child: Text(snap['userName'],
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: size.width * .055,
                          fontFamily: 'BebasNeue-Regular'))),
            ),
          ]),
        ),
      ),
    );
  }
}
