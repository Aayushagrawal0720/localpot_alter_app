import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/DataClasses/SearchLocalityClass.dart';
import 'package:localport_alter/credentials/mapKey.dart';

class PlacesSearchService with ChangeNotifier {
  List<SearchLocalityClass> predictions = [];

  searchPlace(String searchText, double lat, double long) async {
    searchText = searchText.replaceAll(" ", '+');
    lat=23.1815;
    long=79.9864;
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${searchText}&key=$mapKey&types=geocode|establishment&location=$lat,$long&radius=20000&strictbounds";
    // String url =
    //     "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${searchText}&key=$mapKey&types=geocode";
    get(Uri.parse(url)).then((response) {
      try {
        if (response.statusCode == 200) {
          predictions.clear();
          var data = json.decode(response.body);
          var _predictions = data['predictions'];
          for (var p in _predictions) {
            var _description = p['description'];
            var _structured_formatting = p['structured_formatting'];
            var main_text = _structured_formatting['main_text'];
            var secondary_text = _structured_formatting['secondary_text'];
            var place_id = p['place_id'];
            predictions.add(SearchLocalityClass(
                description: _description,
                main_text: main_text,
                secondary_text: secondary_text,
                placeid: place_id));
          }
          notifyListeners();
        }
      } catch (err) {
        print(err);
      }
    });
  }

  getPredictions() => predictions;
}
