import 'package:flutter/cupertino.dart';

class NotVendorAnimationService with ChangeNotifier {
  double _value;

  setValue(double value) {
    _value = value;
    notifyListeners();
  }

  getvalue() => _value;
}
