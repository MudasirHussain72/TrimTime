import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for checking if Shop exists or not?
  static Future<bool> shopExists() async {
    return (await firestore
            .collection('shops')
            .doc(SessionController().userId)
            .get())
        .exists;
  }

  // for adding device token in db
  addDeviceToken(String collectionName, String docId, String deviceToken) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .set({'deviceToken': deviceToken});
  }

  // for checking if Shop doc exists in booking collection or not?
  static Future<bool> shopInBookingsExists(shopUid) async {
    return (await firestore.collection('bookings').doc(shopUid).get()).exists;
  }
}
