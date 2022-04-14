import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/DataClasses/SearchLocalityClass.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';
import 'package:localport_alter/resources/Strings.dart';

class localportNewAddressServices with ChangeNotifier {
  Future<dynamic> saveAddressToServer(bool business, SearchLocalityClass location,
      String completeAddress, String type,
      {String otherAddType, String someoneName, String someonePhone}) async {
    try {
      String id;
      String body;
      if (business) {
        id = await SharedPreferencesClass().getVid();
             } else {
        id = await SharedPreferencesClass().getUid();
      }

      Uri uri = Uri.parse("setaddress");

      Map<String, String> header = {
        "Content-type": "application/json",
        "id": "$id"
      };

      if (type == other) {
        type = otherAddType;
      }
      if (type == customer || type == someone) {
        body =
            '{"primary_loc":"${location.main_text}","secondary_loc":"${location.secondary_text}","completeaddress":"$completeAddress","long":"${location.long}","lat":"${location.lat}","type":"$type","someonename":"$someoneName","someonephone":"$someonePhone"}';
      } else {
        body =
            '{"primary_loc":"${location.main_text}","secondary_loc":"${location.secondary_text}","completeaddress":"$completeAddress","long":"${location.long}","lat":"${location.lat}","type":"$type"}';
      }
      Response response = await post(uri, headers: header, body: body);
      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }
}
