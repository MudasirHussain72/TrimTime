class SessionController {
  static final SessionController _session = SessionController._internal();
  String? userId;
  bool? isBarber;
  double? latitude;
  double? longitude;
  String? addressLine;
  factory SessionController() {
    return _session;
  }

  SessionController._internal();
}
