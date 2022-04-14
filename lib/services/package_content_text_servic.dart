import 'package:flutter/cupertino.dart';

class PackageContentTextService with ChangeNotifier {
  String pctext;

  setText(String text) {
    pctext = text;
    notifyListeners();
  }

  getText() => pctext;
}
