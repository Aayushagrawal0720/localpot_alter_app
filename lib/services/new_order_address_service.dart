import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/DataClasses/SearchLocalityClass.dart';
import 'package:localport_alter/credentials/mapKey.dart';

class NewOrderAddressService with ChangeNotifier {
  int code;
  List<SearchLocalityClass> addList =
      List.generate(4, (index) => SearchLocalityClass());

  /*
  index/code 0: for personal pickup location
  index/code 1: for personal drop location
  index/code 2: for business pickup location
  code 3: for business drop locality
  */

  getLatLongFromText(String place_id) async {
    try {
      String url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$place_id&key=$mapKey';
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var result = data['result'];
        var geometry = result['geometry'];
        var location = geometry['location'];
        var lat = location['lat'];
        var long = location['lng'];

        var latlong = {
          'lat': lat,
          'long': long,
        };
        return latlong;
      }
    } catch (err) {
      print(err);
    }
  }

  setBDropLocation(int index,SearchLocalityClass obj ) async {
    if (obj.lat == null && obj.long == null) {
      var result = await getLatLongFromText(obj.placeid);
      double lat = double.parse(result['lat'].toString());
      double long = double.parse(result['long'].toString());

      obj.lat = lat;
      obj.long = long;
    }

    addList[index] = obj;
    notifyListeners();
  }

  getAddress() => addList;
}
