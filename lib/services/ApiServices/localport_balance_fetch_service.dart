import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class LocalportBalanceFetchService with ChangeNotifier {
  List<Map<String, String>> _balanceList = [];
  bool error = false;

  String _wallet = 'fetching...';

  fetchBalance(String type) async {
    // try {
    await Future.delayed(Duration(milliseconds: 200));
    _balanceList.clear();
    error = false;
    notifyListeners();

    String uid = await SharedPreferencesClass().getUid();
    Uri url = Uri.parse(getbalance);
    Map<String, String> header = {"Content-type": "application/json"};
    String body;
    if (type == null) {
      body = '{"uid":"$uid"}';
    } else {
      body = '{"uid":"$uid", "type":"$type"}';
    }

    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      bool status = data['status'];
      if (status) {
        bool error = false;
        var finalData = data['data'];
        for (var d in finalData) {
          _balanceList.add({d['key']: d['value']});
          if (d['key'] == 'wallet') {
            _wallet = d['value'];
          }
        }
        notifyListeners();
      } else {
        error = true;
        notifyListeners();
      }
    }
    // } catch (err) {
    //   print(err);
    // }
  }

  getError() => error;

  getBalanceData() => _balanceList;

  getWallet() => _wallet;
}
