import 'package:flutter/cupertino.dart';

class NewOrderPageRoundTripService with ChangeNotifier {
  bool _roundTrip = false;

  setRoundTrip(bool roundtrip) {
    this._roundTrip = roundtrip;
    notifyListeners();
  }

  bool getRoundTrip() => _roundTrip;
}
