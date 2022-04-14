import 'package:flutter/cupertino.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';

class DeliveryTypeOrderPage extends ChangeNotifier {
  bool _business = true;
  bool _isUserVendor = true;

  fetchBusinessOwner() async {
    bool isVendor = await SharedPreferencesClass().getIsVendor();
    if (isVendor != null) {
      if (isVendor) {
        _business = true;
        _isUserVendor = true;
        notifyListeners();
        return;
      }
    }
    _business = false;
    _isUserVendor = false;
    notifyListeners();
    return;
  }

  setDelType(bool type) {
    _business = type;
    notifyListeners();
  }

  getDeliveryType() => _business;

  isUserAVendor() => _isUserVendor;
}
