import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter/resources/ServerUrls.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:play_store_scraper/play_store_scraper.dart';

class LocalportHomePageService with ChangeNotifier {
  List<String> _image = [];
  bool isloading = true;
  bool _update = false;
  String _updatePriority = 'low';

  fetchHomePage() async {
    await Future.delayed(Duration(milliseconds: 200));
    isloading = true;
    _image.clear();

    Uri url = Uri.parse(homepage);
    Map<String, String> header = {"Content-type": "application/json"};
    Response response = await get(url, headers: header);
    var resdata = json.decode(response.body);
    bool status = resdata['status'];
    if (status == true) {
      var images = resdata['data'];
      for (var i in images) {
        if (i['filename'] != null) {
          _image.add(i['filename']);
        }
      }
    }
    isloading = false;
    notifyListeners();
  }

  Future checkUpdate() async {
    PlayStoreScraper scraper = PlayStoreScraper();
    var result = await scraper.app(appID: 'com.createwealth.localport_alter');
    ScraperResult _result = result['data'];

    String newVersion = _result.version;

    String currentVersion = await getVersion();
    List<String> _currentList = currentVersion.split('.');
    List<String> _newList = newVersion.split('.');
    for (var n = 0; n <= _newList.length - 1; n++) {
      print('${_newList[n]} : ${_currentList[n]}');
      if (int.parse(_newList[n]) > int.parse(_currentList[n])) {
        // _update = true;
        // notifyListeners();
        return true;
      }
    }
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  List<String> getImages() => _image;

  isHpLoading() => isloading;

  getUpdate() => _update;

  getHighPriority() => _updatePriority == 'high' ? true : false;
}
