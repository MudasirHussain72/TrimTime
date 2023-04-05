import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget {
  final String title;
  VoidCallback oniconTap;
  IconData icon;

  MyAppBar({
    Key? key,
    required this.oniconTap,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                // fontSize: 42,
                fontSize: size.width * .09,
                fontWeight: FontWeight.bold,
                fontFamily: 'BebasNeue-Regular',
              ),
            ),
          ),
          GestureDetector(
            onTap: oniconTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Icon(
                icon,
                size: 36,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
