import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class LocalportInvoiceMonthService with ChangeNotifier {
  Set<String> _months = {};
  bool _loading = true;

  fetchMonths() async {
    await Future.delayed(Duration(milliseconds: 200));
    _loading = true;
    _months.clear();
    notifyListeners();
    String uid = await SharedPreferencesClass().getUid();
    Uri url = Uri.parse(getordermonths);
    Map<String, String> header = {
      "Content-type": "application/json",
      'uid': uid
    };

    Response response = await get(url, headers: header);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      var data = responseData['data'];
      if (status) {
        if (message != 'no record found') {
          for (var d in data) {
            String rawDate = d['value'];
            DateTime datee = DateTime.parse(rawDate);
            datee = datee.toLocal();
            String date = DateFormat.yMMM().format(datee);
            _months.add(date);
          }
        }
        _loading = false;
        notifyListeners();
      } else {}
    }
  }

  isLoading() => _loading;

  Set<String> getMonths() => _months;
}
