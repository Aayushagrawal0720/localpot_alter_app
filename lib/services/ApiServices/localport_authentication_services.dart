import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerConstants.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class localportAuthenticationService with ChangeNotifier {
  bool _loading = false;

  Future<dynamic> login(String phoneNumber) async {
    try {
      await Future.delayed(Duration(microseconds: 200));
      _loading = true;
      notifyListeners();

      Uri uri = Uri.parse(loginUrl);
      Map<String, String> header = {"Content-type": "application/json"};
      var body = '{"mobile": "$phoneNumber"}';
      Response response = await post(uri, headers: header, body: body);
      var responseBody = json.decode(response.body);

      var data = responseBody;
      // bool status = data['status'].toString().toLowerCase() == 'true';
      bool status = data['status'].toString() == 'true';
      String errorcode = data['errorcode'];

      if (status) {
        String uid;
        String fname;
        String lname;
        String mobile;
        bool isvendor = false;
        String vid;
        String vendorName;
        var userData = data['data'];
        uid = userData[0]['uid'];
        for (var u in userData) {
          if (u['key'] == 'fname') {
            fname = u['value'];
          }
          if (u['key'] == 'lname') {
            lname = u['value'];
          }
          if (u['key'] == 'mobile') {
            mobile = u['value'];
          }
          if (u['key'] == 'isvendor') {
            isvendor = u['value'].toString() == 'true';
          }
          if (u['vid'] != null) {
            vid = u['vid'];
          }
          if (u['key'] == 'vname') {
            vendorName = u['value'];
          }
        }
        _loading = false;
        await saveDataToPreferences(uid, fname, lname, mobile, isvendor,
            vid: vid, vendorName: vendorName);
      }
      //Save data to preferences
      return errorcode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<dynamic> signup(
      String uid, String fname, String lname, String phoneNumber) async {
    try {
      Uri uri = Uri.parse(signupUrl);
      Map<String, String> header = {"Content-type": "application/json"};
      var body =
          '{"uid":"$uid", "mobile": "$phoneNumber", "fname":"$fname", "lname": "$lname"}';
      Response response = await post(uri, headers: header, body: body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var data = responseBody;
        bool status = data['status'];
        String errorcode = data['errorcode'];
        if (status) {
          await saveDataToPreferences(uid, fname, lname, phoneNumber, false);
        }
        //Save data to preference
        return errorcode;
      }
      return response.statusCode;
    } catch (err) {
      return 500;
    }
  }

  Future<bool> saveDataToPreferences(
      String uid, String fname, String lname, String phoneNumber, bool vendor,
      {String vid, String vendorName}) async {
    await SharedPreferencesClass().setUid(uid);

    await SharedPreferencesClass().setFName(fname);

    await SharedPreferencesClass().setLName(lname);

    await SharedPreferencesClass().setPhone(phoneNumber);
    await SharedPreferencesClass().setIsVendor(vendor);

    if (vendor && vid != null) {
      await SharedPreferencesClass().setVid(vid);
    }
    if (vendorName != null) {
      await SharedPreferencesClass().setVendorName(vendorName);
    }
    return true;
  }

  bool getLoading() => _loading;
}
