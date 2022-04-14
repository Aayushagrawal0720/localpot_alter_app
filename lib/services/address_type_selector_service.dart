import 'package:flutter/cupertino.dart';

class AddressTypeSelectorService with ChangeNotifier {
  String selected = "";

  selectAddressType(String type) {
    selected = type;
    notifyListeners();
  }

  getSelected() => selected;
}
