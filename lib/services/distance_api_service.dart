import 'dart:convert';
import 'package:http/http.dart';
import 'package:localport_alter/credentials/mapKey.dart';

Future<double> findDistance(
    Map<String, String> pickup, Map<String, String> drop) async {
  double startLatitude = double.parse(pickup['lat']);
  double startLongitude = double.parse(pickup['long']);
  double endLatitude = double.parse(drop['lat']);
  double endLongitude = double.parse(drop['long']);

  Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$startLatitude,$startLongitude&destinations=$endLatitude,$endLongitude&key=$mapKey');

  Response response = await get(url);
  if (response.statusCode == 200) {
    try {
      var responseData = json.decode(response.body);
      String status = responseData['status'];
      if(status=='OK'){
        var rows = responseData['rows'];
        var value = rows[0]['elements'][0]['distance']['value'];
        double distance = double.parse(value.toString());
        // double distance = Geolocator.distanceBetween(
        //     startLatitude, startLongitude, endLatitude, endLongitude);
      return distance;
      }
    } catch (err) {}
  }
}
