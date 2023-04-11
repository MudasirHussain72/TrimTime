import 'package:flutter/material.dart';

class BookingDetailScreen extends StatefulWidget {
  final snap;
  const BookingDetailScreen({super.key, required this.snap});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.snap['userName'])),
      body: Center(
        child:
            TextButton(onPressed: () {}, child: Text('Change serviceStatus')),
      ),
    );
  }
}
