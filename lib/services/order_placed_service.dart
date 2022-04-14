import 'package:flutter/cupertino.dart';

class OrderPlacedService with ChangeNotifier {
  double value = 0;

  setValue(double val) {
    value = val;
    notifyListeners();
  }

  getValue() => value;
}
