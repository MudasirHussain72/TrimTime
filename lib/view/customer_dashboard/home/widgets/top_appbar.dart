import 'package:flutter/material.dart';

class TopAppbar extends StatelessWidget {
  const TopAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * .2,
          child: const Image(image: AssetImage('assets/images/logo.jpg')),
        ),
        Text(
          'King Barber',
          style: TextStyle(
              fontSize: size.width * .06, fontFamily: 'DancingScript-Regular'),
        ),
      ],
    );
  }
}
