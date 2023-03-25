import 'package:barbar_booking_app/res/color.dart';
import 'package:flutter/material.dart';

class ShopDisplayCard extends StatelessWidget {
  // final snap;
  const ShopDisplayCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Container(
      height: size.height / 2.5,
      width: size.width / 1.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.transparent,
                  AppColors.primaryColor,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12),
              child: Text(
                'Shop Name',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: size.width * .055,
                  fontFamily: 'BebasNeue-Regular',
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
