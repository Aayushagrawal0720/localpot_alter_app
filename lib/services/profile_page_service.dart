import 'package:flutter/cupertino.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';

class ProfilePageService with ChangeNotifier {
  String name;
  String mobile;
  bool business;
  String vname;

  fetchProfileInfo() async {
    name = await SharedPreferencesClass().getFName() +
        " " +
        await SharedPreferencesClass().getLName();
    mobile = await SharedPreferencesClass().getPhone();
    business = await SharedPreferencesClass().getIsVendor();
    vname = await SharedPreferencesClass().getVendorName();
    notifyListeners();

    // } catch (err) {
    //   print(err);
    // }
  }

  getName() => name;

  getPhone() => mobile;

  isBusiness() => business;

  getVname()=>vname;
}
