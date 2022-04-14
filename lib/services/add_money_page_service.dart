import 'package:flutter/cupertino.dart';

class AddMoneyPageService with ChangeNotifier{
  double _amount;

  setAmount(double amount){
    _amount=amount;
    notifyListeners();
  }

  getAmount()=>_amount;
}