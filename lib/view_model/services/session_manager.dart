class SessionController {
  static final SessionController _session = SessionController._internal();
  String? userId;
  bool? isBarber;
  factory SessionController() {
    return _session;
  }

  SessionController._internal();
}
