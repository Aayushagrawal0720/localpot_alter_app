import 'package:flutter/cupertino.dart';

class SplashScreenService with ChangeNotifier {
  double value = 0;

  setValue(double val) {
    value = val;
    notifyListeners();
  }

  getValue() => value;
}
