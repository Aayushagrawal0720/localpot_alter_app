import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class LocalportDemandService with ChangeNotifier {
  String _responseMessage = '';

  Future<String> uploadDemandToServer(String demand, String uid) async {
    await Future.delayed(Duration(milliseconds: 200));
    Uri url = Uri.parse(makedemand);
    Map<String, String> header = {"Content-type": "application/json"};
    String body = '{"uid":"$uid","demand":"$demand"}';
    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      _responseMessage = message;
      return _responseMessage;
      notifyListeners();
    }
  }

  getResponseMessage() => _responseMessage;
}
