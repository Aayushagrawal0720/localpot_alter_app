import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class localportOrderHistoryServices with ChangeNotifier {
  List<OrderHistoryObjectClass> _orders = [];
  bool _loading = true;

  fetchOrders(String id, bool business, String status) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      _loading = true;
      _orders.clear();
      notifyListeners();
      Uri url = Uri.parse(getorderFromId);
      Map<String, String> header = {
        "Content-type": "application/json",
      };
      String body = '{"status":"$status","id": "$id"}';

      post(url, body: body, headers: header).then((response) {
        Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        bool status = data['status'];
        String errorcode = data['errorcode'];
        Map<String, dynamic> orderMap = {};
        if (status) {
          var orderdata = data['data'];
          for (var d in orderdata) {
            orderMap[d['oid']] = {'oid': d['oid']};
          }
          for (var d in orderdata) {
            Map<String, dynamic> _temp =
                orderMap[d['oid']] as Map<String, dynamic>;
            _temp[d['key']] = d['value'];
          }
          for (var val in orderMap.values) {
            String rawdate = val['date'];
            DateTime datee = DateTime.parse(rawdate);
            datee = datee.toLocal();
            String date = DateFormat("dd-MM-yyy hh:mm").format(datee);

            List<DeliveryChargeClass> _deliveryCharges = [];
            if (val['price_distribution'] != null) {
              String h =
                  val['price_distribution'].toString().replaceAll('{', '{"');
              h = h.replaceAll(':', '":');
              var priceDistributionObj = json.decode(h);
              for (var d in priceDistributionObj) {
                Map<String, int> _temp = Map<String, int>.from(d);
                _deliveryCharges.add(DeliveryChargeClass(
                    key: _temp.keys.first, value: _temp.values.first));
              }
            }
            _orders.add(
              OrderHistoryObjectClass(
                  weight: val['weight'],
                  // phone: ,
                  id: val['id'],
                  // uid: ,
                  status: val['status'],
                  // fname: ,
                  // lname: ,
                  date: datee,
                  oid: val['oid'],
                  dprice: val['price'],
                  distance: val['distance'],
                  // delInstruction:
                  dropText: val['droploc'],
                  pickutext: val['pickuploc'],
                  // vendorName: ,
                  rName: val['dropname'],
                  rPhone: val['dropphone'],
                  delInstruction: val['delinstruction'],
                  roundTrip: val['round_trip'] == null
                      ? false
                      : val['round_trip'] == 'true',
                  priceDistribution: _deliveryCharges),
            );
          }
          // for (var oid in oids) {
          //   Map<String, dynamic> _orderr={};
          //   for (var d in orderdata) {
          //     if (oid == d['oid']) {
          //
          //       // _orders.add(
          //       //   OrderHistoryObjectClass(
          //       //     weight: d['key'] == 'weight' ? d['value'] : "",
          //       //     // phone: ,
          //       //     id: d['key'] == 'id' ? d['value'] : "",
          //       //     // uid: ,
          //       //     status: d['key'] == 'status' ? d['value'] : "",
          //       //     // fname: ,
          //       //     // lname: ,
          //       //     // date: ,
          //       //     oid: oid,
          //       //     dprice: d['key'] == 'price' ? d['value'] : "",
          //       //     distance: d['key'] == 'distance' ? d['value'] : "",
          //       //     // delInstruction:
          //       //     dropText: d['key'] == 'droploc' ? d['value'] : "",
          //       //     pickutext: d['key'] == 'pickuploc' ? d['value'] : "",
          //       //     // vendorName: ,
          //       //     rName: d['key'] == 'dropname' ? d['value'] : "",
          //       //     rPhone: d['key'] == 'dropphone' ? d['value'] : "",
          //       //   ),
          //       // );
          //     }
          //   }
          // }
        }
        _orders.sort((a,b)=>b.date.compareTo(a.date));
        // _orders = _orders.reversed.toList();
        _loading = false;
        notifyListeners();
      });
    } catch (err) {
      print(err);
    }
  }

  getOrder() => _orders;

  isLoading() => _loading;
}
