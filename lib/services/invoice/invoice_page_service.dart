import 'package:flutter/cupertino.dart';

class InvoicePageService with ChangeNotifier {
  DateTime _initialDate;
  DateTime _endDate;

  String _selectedItem;

  setDate(DateTime date, int check) {
    if (check == 0) {
      _initialDate = date;
    } else {
      _endDate = date;
    }

    notifyListeners();
  }

  String getInitialDate() {
    String date = _initialDate == null
        ? null
        : '${_initialDate.year}-${_initialDate.month}-${_initialDate.day}';
    return date;
  }

  String getEndDate() {
    String date = _endDate == null
        ? null
        : '${_endDate.year}-${_endDate.month}-${_endDate.day}';
    return date;
  }

  setSelectedItem(String index)  async{
    await Future.delayed(Duration(milliseconds: 200));
    _selectedItem = index;
    notifyListeners();
  }

  getSelected() => _selectedItem;
}
