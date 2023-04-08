import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/material.dart';

class ShopBookingCard extends StatelessWidget {
  final shopName;
  final shopAddress;
  VoidCallback oniconTap;

  ShopBookingCard(
      {super.key,
      required this.shopName,
      required this.shopAddress,
      required this.oniconTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 1;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: InkWell(
        onTap: oniconTap,
        child: Container(
          height: size.height * .15,
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
                Text(shopName,
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: size.width * .055,
                        fontFamily: 'BebasNeue-Regular')),
                Text(
                  shopAddress,
                  overflow: TextOverflow.ellipsis,
                )
              ]),
        ),
      ),
    );
  }
}
