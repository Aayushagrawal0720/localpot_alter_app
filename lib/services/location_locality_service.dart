import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:localport_alter/DataClasses/SearchLocalityClass.dart';
import 'package:localport_alter/credentials/mapKey.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';

class LocationLocalityService with ChangeNotifier {
  String localityName;
  double lat;
  double long;
  List<SearchLocalityClass> placemark = [];
  SearchLocalityClass _singleLocation;
  bool setByUser = false;

  resetService() {
    localityName = null;
    lat = null;
    long = null;
    placemark = [];
    _singleLocation = null;
    setByUser = false;
  }

  fetchLocality(BuildContext context) async {
    if (!setByUser) {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await enableLocationServiceDialog(context);
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation)
          .then((position) async {
        lat = position.latitude;
        long = position.longitude;

        List<Placemark> _placemark = await placemarkFromCoordinates(lat, long);
        if (_placemark.isNotEmpty) {
          placemark.clear();
          _singleLocation = SearchLocalityClass(
              main_text: _placemark[0].street,
              secondary_text:
                  "${_placemark[0].subLocality}, ${_placemark[0].locality}, ${_placemark[0].subAdministrativeArea}");

          _placemark.forEach((element) async {
            if (element.subLocality != "") {
              String secondry_text =
                  "${element.subLocality}, ${element.locality}, ${element.subAdministrativeArea}";

              SearchLocalityClass _sc = SearchLocalityClass(
                  main_text: element.street,
                  secondary_text: secondry_text,
                  lat: lat,
                  long: long);

              placemark.add(_sc);
            }
          });
        }
        notifyListeners();
      });
    }
  }

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

  setSingleLocation(SearchLocalityClass location) async {
    if (location.lat == null && location.long == null) {
      var result = await getLatLongFromText(location.placeid);
      double lat = double.parse(result['lat'].toString());
      double long = double.parse(result['long'].toString());

      location.lat = lat;
      location.long = long;
    }

    _singleLocation = location;
    setByUser = true;
    notifyListeners();
  }

  getSingleNearbyLocation() => _singleLocation == null ? null : _singleLocation;

  getNearbyLocationList() => placemark;

  getLocality() => {'locality': localityName, 'lat': lat, 'long': long};
}
