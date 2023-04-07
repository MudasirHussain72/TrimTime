import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  final serviceName;
  final servicePrice;
  final serviceUid;
  final shopUid;
  const BookAppointmentScreen(
      {super.key,
      required this.serviceName,
      required this.servicePrice,
      required this.serviceUid,
      required this.shopUid});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String? shopUid;
  String? shopDeviceToken;
  void showDisplayName() async {
    var collection = FirebaseFirestore.instance.collection('deviceTokens');
    var docSnapshot = await collection.doc(shopUid).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    shopDeviceToken = data['deviceToken'];
  }

  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    shopUid = widget.shopUid;
    mockBookingService = BookingService(
      serviceName: widget.serviceName,
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

  ///This is how you upload data to Firestore
  Future<dynamic> uploadBookingFirebase(
      {required BookingService newBooking}) async {
    await bookings.doc(SessionController().userId).set({
      'shopUid': widget.shopUid,
    }).then((value) => bookings
        .doc(SessionController().userId)
        .collection('bookings')
        .add(newBooking.toJson())
        .then((value) => print("Booking Added"))
        .catchError((error) => print("Failed to add booking: $error")));
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
          disabledDays: [6, 7],
        ),
      ),
    );
  }
}
