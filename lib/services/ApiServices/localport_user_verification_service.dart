import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/pages/authentication/SigninScreen.dart';
import 'package:localport_alter/resources/ServerConstants.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class localportUserVerificationService with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  verifyUser() async {
    try {
      await SharedPreferencesClass().getUid().then((value) {
        if (value == null || value == "null") {
          _auth.signOut();
          return USER_NOT_FOUND;
        }
      });
      if (_auth.currentUser != null) {
        String phone = _auth.currentUser.phoneNumber;
        if (phone != null) {
          Uri url = Uri.parse(loginUrl);
          Map<String, String> _headers = {
            'Content-type': "application/json",
          };
          var _body = '{"mobile": "$phone"}';

          Response _response = await post(url, headers: _headers, body: _body);
          if (_response.statusCode == 201) {
            _auth.signOut();
          }
          var responseData = json.decode(_response.body);
          bool status = responseData['status'];
          String errorcode = responseData['errorcode'];
          if (status) {
            return true;
          } else {
            return errorcode;
          }
        } else {
          _auth.signOut();
          return 201;
        }
      } else {
        _auth.signOut();
        return 201;
      }
    } catch (err) {
      print(err);
      return 500;
    }
  }
}
