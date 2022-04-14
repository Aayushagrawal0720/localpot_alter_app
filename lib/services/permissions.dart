import 'package:permission_handler/permission_handler.dart';

getStoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isGranted) {
    return true;
  } else {
    var value = await Permission.storage.request();
    if (value.isGranted) {
      return true;
    } else {
      return false;
    }
}}