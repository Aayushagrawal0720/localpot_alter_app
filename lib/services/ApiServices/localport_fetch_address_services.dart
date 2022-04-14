// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart';
// import 'package:localport_alter/DataClasses/UserAddressClass.dart';
// import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
// import 'package:localport_alter/resources/ServerUrls.dart';
//
// class localportFetchAddressesServices with ChangeNotifier {
//   List<UserAddressClass> _userAddress;
//   bool _loading=true;
//
//   fetchAddresses() async {
//     try {
//
//       if(!_loading){
//         _loading=true;
//         notifyListeners();
//       }
//
//       _userAddress=[];
//       String uid = await SharedPreferencesClass().getUid();
//
//       Uri uri = Uri.parse(getaddressbyuid);
//       Map<String, String> header = {
//         "Content-type": "application/json",
//         "uid": uid
//       };
//
//
//
//       post(uri, headers: header).then((response) {
//         if (response.statusCode == 200 && response.body!="no record found") {
//           print(response.body);
//           var data = json.decode(response.body);
//           for (var d in data) {
//             _userAddress.add(UserAddressClass(
//               aid: d['aid'].toString(),
//               id: d['id'].toString(),
//               completeaddress: d['completeaddress'].toString(),
//               primary_loc: d['primary_loc'].toString(),
//               secondary_loc: d['secondary_loc'].toString(),
//               lat: d['lat'].toString(),
//               long: d['long'].toString(),
//               type: d['type'].toString(),
//               belongsTo: d['belongsto'].toString(),
//               belongsToid: d['belongsto'].toString() == 'self'
//                   ? "self"
//                   : d['belongsto']['sid'].toString(),
//               belongsToPhone: d['belongsto'].toString() == 'self'
//                   ? "self"
//                   : d['belongsto']['sphone'].toString(),
//               belongsToName: d['belongsto'].toString() == 'self'
//                   ? "self"
//                   : d['belongsto']['sname'].toString(),
//             ));
//           }
//
//         }
//         _loading=false;
//         notifyListeners();
//       });
//     } catch (err) {
//       print(err);
//       return 500;
//     }
//   }
//
//   isLoading()=>_loading;
//
//   getAddress()=>_userAddress;
// }
