import 'dart:convert';
import 'dart:developer';

import 'package:barbar_booking_app/api/apis.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class BookAppointmentScreen extends StatefulWidget {
  final serviceName;
  final servicePrice;
  final serviceUid;
  final shopUid;
  final shopName;
  final shopAddress;
  final userName;
  const BookAppointmentScreen({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceUid,
    required this.shopUid,
    required this.shopName,
    required this.shopAddress,
    required this.userName,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String? shopUid;
  String? shopDeviceToken;
  var bookingDocId;
  var uuid = Uuid();

  final now = DateTime.now();
  late BookingService mockBookingService;
  Future<void> _getshopDeviceToken() async {
    FirebaseFirestore.instance
        .collection('deviceTokens')
        .doc(shopUid)
        .get()
        .then((value) {
      setState(() {
        shopDeviceToken = value.data()!['deviceToken'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      bookingDocId = uuid.v4();
      shopUid = widget.shopUid;
    });
    _getshopDeviceToken();
    mockBookingService = BookingService(
      bookingDocumentId: bookingDocId,
      serviceStatus: false,
      serviceName: widget.serviceName,
      userName: widget.userName,
      serviceDuration: 30,
      bookingEnd: DateTime(now.year, now.month, now.day, 23, 0),
      bookingStart: DateTime(now.year, now.month, now.day, now.hour, 0),
      serviceId: widget.serviceUid,
      servicePrice: int.parse(widget.servicePrice),
      userId: SessionController().userId,
    );
  }

  CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');

  ///This is how can you get the reference to your data from the collection, and serialize the data with the help of the Firestore [withConverter]. This function would be in your repository.
  CollectionReference getBookingStream({required String placeId}) {
    return bookings
        .doc(placeId)
        .collection('bookings')
        .withConverter<BookingService>(
          fromFirestore: (snapshots, _) =>
              BookingService.fromJson(snapshots.data()!),
          toFirestore: (snapshots, _) => snapshots.toJson(),
        );
  }

  ///How you actually get the stream of data from Firestore with the help of the previous function
  ///note that this query filters are for my data structure, you need to adjust it to your solution.
  Stream? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    return getBookingStream(placeId: widget.shopUid)
        // .where('bookingStart', isGreaterThanOrEqualTo: start)
        // .where('bookingStart', isLessThanOrEqualTo: end)
        .snapshots();
  }

  List<DateTimeRange> convertStreamResultFirebase(
      {required dynamic streamResult}) {
    List<DateTimeRange> converted = [];
    for (var i = 0; i < streamResult.size; i++) {
      final item = streamResult.docs[i].data();
      converted.add(
          DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    return converted;
  }

  ///This is how you upload data to Firestore
  Future<dynamic> uploadBookingFirebase(
      {required BookingService newBooking}) async {
    if (await APIs.shopInBookingsExists(shopUid)) {
      await bookings.doc(widget.shopUid).update({
        // 'bookings': [].add(SessionController().userId),
        'bookings': FieldValue.arrayUnion([SessionController().userId]),
      }).then((value) => bookings
              .doc(widget.shopUid)
              .collection('bookings')
              .doc(bookingDocId!)
              .set(newBooking.toJson())
              .then((value) async {
            log(shopDeviceToken.toString());
            log(bookingDocId.toString());
            // notification functionality will be written here
            var data = {
              'to': shopDeviceToken,
              'priority': 'high',
              // 'android': {
              'notification': {
                'title': 'Hello Dear',
                'body':
                    'Booking from ${widget.userName} for ${widget.serviceName}',
                'android_channel_id': "Messages",
                'count': 10,
                'notification_count': 12,
                'badge': 12,
                "click_action": 'asif',
                'color': '#eeeeee',
              },
              // },
              'data': {
                'type': 'msg',
                // 'id': '12456',
              }
            };
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization':
                      'key=AAAA-DnuRMI:APA91bEqnn3baxUKSOAGZL_aPhNRzZO_NIH4ITJl5Hkp6eUux7LHZX5IDuHgRorG7R3q5YBZ_2qUEsXnq5X8OBo9h9iRg1RHfyMaD0hm1oI4TfrIyl3zHKpYRwrvM-TShXcl-nemfZNU'
                });
            Navigator.pop(context);
            Utils.flushBarDoneMessage("Booking Added", BuildContext, context);
            print("Booking Added");
          }).catchError((error) => print("Failed to add booking: $error")));
    } else {
      await bookings.doc(widget.shopUid).set({
        'shopUid': widget.shopUid,
        'shopName': widget.shopName,
        'shopAddress': widget.shopAddress,
        'bookings': [SessionController().userId],
      }).then((value) => bookings
              .doc(widget.shopUid)
              .collection('bookings')
              .doc(bookingDocId!)
              .set(newBooking.toJson())
              .then((value) async {
            log(shopDeviceToken.toString());
            log(bookingDocId.toString());

            // notification functionality will be written here
            var data = {
              'to': shopDeviceToken,
              'priority': 'high',
              // 'android': {
              'notification': {
                'title': 'Hello Dear',
                'body':
                    'Booking from ${widget.userName} for ${widget.serviceName}',
                'android_channel_id': "Messages",
                'count': 10,
                'notification_count': 12,
                'badge': 12,
                "click_action": 'asif',
                'color': '#eeeeee',
              },
              // },
              'data': {
                'type': 'msg',
                // 'id': '12456',
              }
            };
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization':
                      'key=AAAA-DnuRMI:APA91bEqnn3baxUKSOAGZL_aPhNRzZO_NIH4ITJl5Hkp6eUux7LHZX5IDuHgRorG7R3q5YBZ_2qUEsXnq5X8OBo9h9iRg1RHfyMaD0hm1oI4TfrIyl3zHKpYRwrvM-TShXcl-nemfZNU'
                });
            Navigator.pop(context);
            Utils.flushBarDoneMessage("Booking Added", BuildContext, context);
            print("Booking Added");
          }).catchError((error) => print("Failed to add booking: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.serviceName} Booking'.toUpperCase()),
      ),
      body: Center(
        child: BookingCalendar(
          bookingService: mockBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultFirebase,
          getBookingStream: getBookingStreamFirebase,
          uploadBooking: uploadBookingFirebase,
          loadingWidget: const Text('Fetching data...'),
          uploadingWidget: const CircularProgressIndicator(),
          startingDayOfWeek: StartingDayOfWeek.tuesday,
          wholeDayIsBookedWidget:
              const Text('Sorry, for this day everything is booked'),
          disabledDays: const [6, 7],
        ),
      ),
    );
  }
}
