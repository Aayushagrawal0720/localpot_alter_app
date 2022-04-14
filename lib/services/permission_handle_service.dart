import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandleService with ChangeNotifier {
  bool _isInProgress = false;
  bool _isLocationPermission = false;
  bool _isLocationPermanentlyDenied = false;
  bool _fetched = false;

  getFetched() => _fetched;

  getIsInProgress() => _isInProgress;

  getIsLocationPermission() => _isLocationPermission;

  getIsLocationPermanentlyDenied() => _isLocationPermanentlyDenied;

  _setProgressTrue() {
    _isInProgress = true;
    _fetched=false;
    notifyListeners();
  }

  checkForPermission() async {
    _setProgressTrue();
    Permission.location.status.then((value) {
      if (value.isGranted) {
        _fetched = true;
        _isLocationPermission = true;
        _isInProgress = false;
        notifyListeners();
      }
      if (value.isDenied) {
        _fetched = true;
        _isLocationPermission = true;
        _isInProgress = false;
        notifyListeners();
        Permission.location.request().then((value) {
          if(!value.isPermanentlyDenied) {
            checkForPermission();
          }else{
            _fetched = true;
            _isLocationPermission = false;
            _isInProgress = false;
            _isLocationPermanentlyDenied = true;
            notifyListeners();
          }
        });
      }
      if (value.isPermanentlyDenied) {
        _fetched = true;
        _isLocationPermission = false;
        _isInProgress = false;
        _isLocationPermanentlyDenied = true;
        notifyListeners();
      }
      if (value.isRestricted) {
        _fetched = true;
        _isLocationPermission = false;
        _isInProgress = false;
        _isLocationPermanentlyDenied = true;
        notifyListeners();
        Permission.location.request().then((value) {
          if(!value.isPermanentlyDenied) {
            checkForPermission();
          }else{
            _fetched = true;
            _isLocationPermission = false;
            _isInProgress = false;
            _isLocationPermanentlyDenied = true;
            notifyListeners();
          }
        });
      }
    });
  }
}
