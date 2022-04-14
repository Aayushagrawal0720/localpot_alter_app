import 'package:flutter/cupertino.dart';

class PackageWeightTextService with ChangeNotifier {
  String pwtext;

  setText(String text) {
    pwtext = text;
    notifyListeners();
  }

  getText() => pwtext;
}
