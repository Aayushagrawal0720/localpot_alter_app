import 'package:flutter/cupertino.dart';

class ReceiverContactService with ChangeNotifier {
  Map<String, String> _personalContact={};
  Map<String, String> _vendorContact={};

  setContactDetails(Map<String, String> contact, bool vendor)  async {
    _personalContact.clear();
    _vendorContact.clear();
    await Future.delayed(Duration(milliseconds: 200));
    if (vendor) {
      this._vendorContact = contact;
    } else {
      this._personalContact = contact;
    }
    notifyListeners();
  }

  getPersonalContact()=>_personalContact;
  getVendorContact()=>_vendorContact;
}
