import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  String _UID = 'uid';
  String _FNAME = 'fname';
  String _LNAME = 'lname';
  String _PHONE = 'phone';
  String _ISVENDOR = 'isvendor';
  String _VID = 'vid';
  String _VENDORNAME= 'vendor_name';

  setUid(String uid) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_UID, uid);
  }

  Future<String> getUid() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_UID);
  }

  setFName(String fname) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_FNAME, fname);
  }

  Future<String> getFName() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_FNAME);
  }

  setLName(String lname) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_LNAME, lname);
  }

  getLName() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_LNAME);
  }

  setPhone(String phone) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_PHONE, phone);
  }

  getPhone() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_PHONE);
  }

  setIsVendor(bool vendor) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setBool(_ISVENDOR, vendor);
  }

  getIsVendor() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getBool(_ISVENDOR);
  }

  setVid(String vid) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_VID, vid);
  }

  getVid() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_VID);
  }

  setVendorName(String name) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_VENDORNAME, name);
  }

  getVendorName() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_VENDORNAME);
  }
}
