import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class localportLandingpageImageService with ChangeNotifier {
  List<Uint8List> _images = [];
  bool loading = false;

  fetchImages() {
    if (!loading) {
      try {
        loading=true;
        _images.clear();
        Uri uri = Uri.parse(getproimages);
        Map<String, String> header = {
          "Content-type": "application/json",
        };
        get(uri, headers: header).then((response) {
          if (response.body != "server error") {
            var data = json.decode(response.body);
            for (var d in data) {
              String image= d['image'].toString();
              _images.add(base64Decode(image));
            }
            notifyListeners();
          }
        });
      } catch (err) {
        print(err);
      }
    }
  }

  getImages() => _images;
}
