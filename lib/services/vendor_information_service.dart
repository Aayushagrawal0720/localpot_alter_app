import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class VendorInformationService with ChangeNotifier {
  bool _isVendor = true;
  File _finalImage;
  String _imagePath;

  getIsVendor() => _isVendor;

  setIsVendor(bool value) {
    _isVendor = value;
    notifyListeners();
  }

  setImage(File image) async {
    _finalImage= image;
    notifyListeners();
  }

  getImage()=>_finalImage;
}
