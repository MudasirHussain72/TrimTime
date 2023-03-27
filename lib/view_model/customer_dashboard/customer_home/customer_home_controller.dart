import 'package:flutter/foundation.dart';

class CustomerHomeController with ChangeNotifier {
  String _addressLine = "Islamabad Capital of Pakistan";
  double _latitude = 33.6844;
  double _longitude = 73.0479;
  String get addressLine => _addressLine;
  double get latitude => _latitude;
  double get longitude => _longitude;
  // for getting ADDRESS
  setAddress(String value) {
    _addressLine = value;
    notifyListeners();
  }

  // for getting latitude
  setLatitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  // for getting longitude
  setLongitude(double value) {
    _longitude = value;
    notifyListeners();
  }
}
