import 'dart:convert';
import 'dart:developer';

import 'package:barbar_booking_app/api/apis.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  Map<String, dynamic>? paymentIntentData;
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
    makePayment(newBooking);
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

  Future<void> makePayment(newBooking) async {
    try {
      paymentIntentData =
          await createPaymentIntent('20', 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret: 'Your Secret Key',
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  //applePay: PaymentSheetApplePay.,
                  //googlePay: true,
                  //testEnv: true,
                  customFlow: true,
                  style: ThemeMode.dark,
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'Kashif'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(newBooking);
    } catch (e, s) {
      print('Payment exception:$e$s');
    }
  }

  displayPaymentSheet(newBooking) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              //       parameters: PresentPaymentSheetParameters(
              // clientSecret: paymentIntentData!['client_secret'],
              // confirmPayment: true,
              // )
              )
          .then((newValue) async {
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
                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAA-DnuRMI:APA91bEqnn3baxUKSOAGZL_aPhNRzZO_NIH4ITJl5Hkp6eUux7LHZX5IDuHgRorG7R3q5YBZ_2qUEsXnq5X8OBo9h9iRg1RHfyMaD0hm1oI4TfrIyl3zHKpYRwrvM-TShXcl-nemfZNU'
                    });
                Navigator.pop(context);
                Utils.flushBarDoneMessage(
                    "Booking Added", BuildContext, context);
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
                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAA-DnuRMI:APA91bEqnn3baxUKSOAGZL_aPhNRzZO_NIH4ITJl5Hkp6eUux7LHZX5IDuHgRorG7R3q5YBZ_2qUEsXnq5X8OBo9h9iRg1RHfyMaD0hm1oI4TfrIyl3zHKpYRwrvM-TShXcl-nemfZNU'
                    });
                Navigator.pop(context);
                Utils.flushBarDoneMessage(
                    "Booking Added", BuildContext, context);
                print("Booking Added");
              }).catchError((error) => print("Failed to add booking: $error")));
        }
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount('20'),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' +
                'sk_test_51NN7cLEPQNvlYGTyubM52NlJ051ijsPJouRXfgiS1dJbpGTxOtHRtQNC8xxy17DoiYNVMJBkOOEKxK8196XFYYDa00a7FQ2rx1',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
