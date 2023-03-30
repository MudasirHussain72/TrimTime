import 'package:barbar_booking_app/utils/utils.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class AddServiceController with ChangeNotifier {
  final firestore = FirebaseFirestore.instance.collection('users');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

// post Add
  postAdd(BuildContext context, String serviceName, String price,
      dynamic image) async {
    setLoading(true);
    var id = Uuid().v4();
    try {
      // firestore.doc(SessionController().userId).collection('services').add({});
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/profileImage/${SessionController().userId}/services/$id');
      firebase_storage.UploadTask uploadTask = ref.putFile(image);
      await Future.value(uploadTask);
      final newUrl = await ref.getDownloadURL();
      await firestore
          .doc(SessionController().userId)
          .collection('services')
          .doc(id)
          .set({
        'price': price,
        'serviceName': serviceName,
        'serviceImage': newUrl,
        'id': id,
      }).then((value) {
        setLoading(false);
        Navigator.pop(context);
        Utils.toastMessage('profile picture updated');
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
      Utils.toastMessage(e.toString());
    }
  }
}
