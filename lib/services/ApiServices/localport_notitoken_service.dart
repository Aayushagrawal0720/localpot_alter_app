import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class LocalportNotificationTokenService {
  sendToken(String token) async {
    String uid = await SharedPreferencesClass().getUid();
    Uri url = Uri.parse(settoken);
    Map<String, String> header = {"Content-type": "application/json"};
    var body =
        '{"uid":"$uid", "token": "$token"}';
    Response response=  await post(url, headers: header, body: body);
  }
}
