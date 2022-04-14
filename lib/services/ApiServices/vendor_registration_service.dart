import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class VendorRegistrationService with ChangeNotifier {
  Future<dynamic> saveVendor(
      String uid, String businessName, String description, String image) async {
    try {
      // String uid = await SharedPreferencesClass().getUid();
      Uri uri = Uri.parse(registervendor);
      Map<String, String> header = {"Content-type": "application/json"};
      var body =
          '{"uid":"$uid","vendorname":"$businessName", "logo": "$image", "about":"$description"}';

      Response _response = await post(uri, headers: header, body: body);
      var data = json.decode(_response.body);
      bool status = data['status'];
      String errorcode = data['errorcode'];
      var vendorData= data['data'];
      if (status) {
        await SharedPreferencesClass().setIsVendor(true);
        await SharedPreferencesClass().setVid(vendorData['vid']);
        await SharedPreferencesClass().setVendorName(businessName);
      }
      return errorcode;
    } catch (err) {
      print(err);
      return 500;
    }
  }
}
