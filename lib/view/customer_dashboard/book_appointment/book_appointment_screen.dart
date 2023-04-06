import 'dart:developer';

import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
      serviceName: 'Mock Service',
      serviceDuration: 30,
      bookingEnd: DateTime(now.year, now.month, now.day, 22, 0),
      bookingStart: DateTime(now.year, now.month, now.day, now.hour, 0),
      // bookingStart: now,
    );
  }

  // Stream<dynamic>? getBookingStreamMock(
  //     {required DateTime end, required DateTime start}) {
  //   return Stream.value([]);
  // }

  // Future<dynamic> uploadBookingMock(
  //     {required BookingService newBooking}) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   converted.add(DateTimeRange(
  //       start: newBooking.bookingStart, end: newBooking.bookingEnd));
  //   FirebaseFirestore.instance
  //       .collection('bookings')
  //       .doc(SessionController().userId)
  //       .collection('bookings')
  //       .doc()
  //       .set(newBooking.toJson());
  //   log('${newBooking.toJson()} has been uploaded');
  // }

  // List<DateTimeRange> converted = [];

  // List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
  //   ///here you can parse the streamresult and convert to [List<DateTimeRange>]
  //   ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
  //   ///disabledDays will properly work with real data
  //   DateTime first = now;
  //   DateTime tomorrow = now.add(Duration(days: 1));
  //   DateTime second = now.add(const Duration(minutes: 55));
  //   DateTime third = now.subtract(const Duration(minutes: 240));
  //   DateTime fourth = now.subtract(const Duration(minutes: 500));
  //   converted.add(
  //       DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
  //   converted.add(DateTimeRange(
  //       start: second, end: second.add(const Duration(minutes: 23))));
  //   converted.add(DateTimeRange(
  //       start: third, end: third.add(const Duration(minutes: 15))));
  //   converted.add(DateTimeRange(
  //       start: fourth, end: fourth.add(const Duration(minutes: 50))));

  //   //book whole day example
  //   converted.add(DateTimeRange(
  //       start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
  //       end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
  //   return converted;
  // }

  // List<DateTimeRange> generatePauseSlots() {
  //   return [
  //     DateTimeRange(
  //         start: DateTime(now.year, now.month, now.day, 12, 0),
  //         end: DateTime(now.year, now.month, now.day, 13, 0))
  //   ];
  // }
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
  // Stream<dynamic>? getBookingStreamFirebase(
  //     {required DateTime end, required DateTime start}) {
  //   // return getBookingStream(placeId: SessionController().userId.toString())
  //   //     .where('bookingStart', isGreaterThanOrEqualTo: start)
  //   //     .where('bookingStart', isLessThanOrEqualTo: end)
  //   //     .snapshots();
  //   bookings
  //       .doc(SessionController().userId.toString())
  //       .collection('bookings')
  //       .withConverter<BookingService>(
  //         fromFirestore: (snapshots, _) =>
  //             BookingService.fromJson(snapshots.data()!),
  //         toFirestore: (snapshots, _) => snapshots.toJson(),
  //       )
  //       .where('bookingStart', isGreaterThanOrEqualTo: start)
  //       .where('bookingStart', isLessThanOrEqualTo: end)
  //       .snapshots();
  // }
  Stream? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    return getBookingStream(placeId: SessionController().userId.toString())
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

  ///After you fetched the data from firestore, we only need to have a list of datetimes from the bookings:
  // List<DateTimeRange> convertStreamResultFirebase(
  //     {required dynamic streamResult}) {
  //   ///here you can parse the streamresult and convert to [List<DateTimeRange>]
  //   ///Note that this is dynamic, so you need to know what properties are available on your result, in our case the [SportBooking] has bookingStart and bookingEnd property
  //   List<DateTimeRange> converted = [];
  //   for (var i = 0; i < streamResult.size; i++) {
  //     final item = streamResult.docs[i].data();
  //     converted.add(
  //         DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
  //   }
  //   return converted;
  // }

  ///This is how you upload data to Firestore
  Future<dynamic> uploadBookingFirebase(
      {required BookingService newBooking}) async {
    await bookings
        .doc(SessionController().userId)
        .collection('bookings')
        .add(newBooking.toJson())
        .then((value) => print("Booking Added"))
        .catchError((error) => print("Failed to add booking: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Calendar Demo'),
      ),
      body: Center(
        child: BookingCalendar(
          bookingService: mockBookingService,
          // bookingService: BookingService(
          //     bookingStart: DateTime.now(),
          //     bookingEnd: DateTime.utc(2023, 7, 20, 20, 18, 04),
          //     serviceDuration: 30,
          //     serviceName: "Meeting"),
          // convertStreamResultToDateTimeRanges: convertStreamResultMock,
          // getBookingStream: getBookingStreamMock,
          // uploadBooking: uploadBookingMock,
          // pauseSlots: generatePauseSlots(),
          convertStreamResultToDateTimeRanges: convertStreamResultFirebase,
          getBookingStream: getBookingStreamFirebase,
          uploadBooking: uploadBookingFirebase,
          loadingWidget: const Text('Fetching data...'),
          uploadingWidget: const CircularProgressIndicator(),
          startingDayOfWeek: StartingDayOfWeek.tuesday,
          wholeDayIsBookedWidget:
              const Text('Sorry, for this day everything is booked'),
          disabledDays: [6, 7],
        ),
      ),
    );
  }
}
