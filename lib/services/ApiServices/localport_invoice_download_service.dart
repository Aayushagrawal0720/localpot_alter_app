import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../permissions.dart';

class LocalportInvoiceDownloadService with ChangeNotifier {
  String _url = '';
  bool _creating = true;
  bool _downloading = true;
  bool _noPermission = false;

  generateInvoice(String date) async {
    await Future.delayed(Duration(milliseconds: 200));
    _creating = true;
    _downloading = true;
    _url = '';
    notifyListeners();

    Uri url = Uri.parse(downloadinvoice);
    String uid = await SharedPreferencesClass().getUid();
    Map<String, String> header = {
      "Content-type": "application/json",
    };

    String body = '{"uid":"$uid", "date":"$date"}';
    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      if (status) {
        var data = responseData['data'];
        _url = data['url'];
        _creating = false;
        downloadInvoice(date);
        notifyListeners();
      } else {
        _creating = false;
        _downloading = false;
      }
    }
  }

  downloadInvoice(String month) async {
    Uri url = Uri.parse(invoiceUrl + _url);
    month = month.replaceAll(" ", '_');
    File file;
    String filePath;
    String fileName = 'localport_invoice_$month.pdf';
    Directory dir = await getExternalStorageDirectory();
    HttpClient httpClient = HttpClient();
    var request = await httpClient.getUrl(url);
    var response = await request.close();
    if (response.statusCode == 200) {
      bool status = await getStoragePermission();
      if (status) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '${dir.path}/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        _downloading = false;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 200));
        OpenFile.open(filePath);
      } else {
        _downloading = false;
        _noPermission = true;
        notifyListeners();
      }
    }
  }

  isCreating() => _creating;

  isDownloading() => _downloading;
}
