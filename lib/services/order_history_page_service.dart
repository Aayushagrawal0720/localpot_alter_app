import 'package:flutter/cupertino.dart';

class OrderHistoryPageService with ChangeNotifier {
  String _status = "All";
  String _orderHistorySearchType = 'Individual';

  setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  Future setOrderHistorySearchType(String type) async {
    _orderHistorySearchType = type;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
  }

  getOrderHistorySearchStatus() => _status;

  getOrderHistorySearchType() => _orderHistorySearchType;
}
