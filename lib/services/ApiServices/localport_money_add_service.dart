import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class LocalportMoneyAddService with ChangeNotifier {
  addMoneyToWallet(String uid, String amount, String status, String type,
      String dfrom, String gateway_result) async {
    try {
      Uri url = Uri.parse(addmoney);
      Map<String, String> header = {"Content-type": "application/json"};
      String body =
          '{"uid":"$uid", "amount":"$amount", "status":"$status", "type":"$type", "dfrom":"$dfrom", "gateway_result":"$gateway_result"}';
      Response response = await post(url, headers: header, body: body);
      if(response.statusCode==200){
        var dat = json.decode(response.body);
        bool status = dat['status'];
        return status;
      }
      return false;
    } catch (e) {
      print(e);

      return false;
    }
  }
}
