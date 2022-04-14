import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localport_alter/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/ServerUrls.dart';

class localportOrderPlaceService with ChangeNotifier {
  bool _business;
  String _id;
  String _weight;
  String _cname;
  String _cphone;
  String _distance;
  String _delPrice;
  String _pickupText;
  String _dropText;
  String _pickuplatlong;
  String _droplatlong;
  String _delInstruction;

  bool _fetchingDeliveryPrice = true;
  bool _alreadySent = false;
  String _uid;
  bool _roundTrip;
  double _totalAmount = 0;

  List<DeliveryChargeClass> _deliveryCharges = [];

  setData(
      bool _business,
      String id,
      String pickuptext,
      String droptext,
      String weight,
      String cname,
      String cphone,
      String distance,
      String pickuplatlong,
      String droplatlong,
      String delInstruction,
      String uid,
      bool roundTrip,
      {String delAmt}) {
    this._business = _business;
    this._id = id;
    this._pickupText = pickuptext;
    this._dropText = droptext;
    this._weight = weight;
    this._cname = cname;
    this._cphone = cphone;
    this._distance = distance;
    this._pickuplatlong = pickuplatlong;
    this._droplatlong = droplatlong;
    this._delInstruction = delInstruction;
    this._uid = uid;
    this._roundTrip = roundTrip;
    if (delAmt != null) {
      this._delPrice = delAmt;
    }
  }

  Future fetchDeliveryCharge() async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      _fetchingDeliveryPrice = true;
      _alreadySent = true;
      _totalAmount = 0;
      _deliveryCharges.clear();
      if (_delPrice != null) {
        _fetchingDeliveryPrice = false;
        _alreadySent = false;
      }
      notifyListeners();
      Uri url = Uri.parse(fetchdeliveryprice);
      String finalWeight = _weight.replaceAll(new RegExp(r'[^0-9]'), '');
      Map<String, String> header = {
        "Content-type": "application/json",
      };
      String body =
          '{"weight":"${finalWeight}","distance": "${_distance}","vendor": $_business,"roundtrip": $_roundTrip,"uid": "$_uid"}';

      post(url, body: body, headers: header).then((response) {
        var data = json.decode(response.body);
        bool status = data['status'];
        String errorcode = data['errorcode'];
        var resData = data['data'];
        _alreadySent = false;
        if (status) {
          for (var d in resData) {
            Map<String, int> _temp = Map<String, int>.from(d);
            _totalAmount = _totalAmount + _temp.values.first;
            _deliveryCharges.add(DeliveryChargeClass(
                key: _temp.keys.first.toString(), value: _temp.values.first));
          }
          _fetchingDeliveryPrice = false;
          notifyListeners();
          return errorcode;
        } else {
/*          _fetchingDeliveryPrice = tru;
          notifyListeners();*/
          return errorcode;
        }
      });
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<dynamic> placeOrder() async {
    try {
      Uri url = Uri.parse(placeorder);
      String finalWeight = _weight.replaceAll(new RegExp(r'[^0-9]'), '');
      var _price = [];
      _deliveryCharges.forEach((element) {
        _price.add({element.key: element.value});
      });
      Map<String, dynamic> body = {
        "id": "$_id",
        "uid": "$_uid",
        "pickuploc": "$_pickupText",
        "pickuplatlong": "$_pickuplatlong",
        "droploc": "$_dropText",
        "droplatlong": "$_droplatlong",
        "dropname": "$_cname",
        "dropphone": "$_cphone",
        "weight": "$finalWeight",
        "distance": "$_distance",
        "price": "$_totalAmount",
        "delinstruction": "$_delInstruction",
        "pricedistribution": "$_price",
        "roundtrip": "$_roundTrip"
      };
      Map<String, String> header = {"Content-type": "application/json"};
      Response response = await post(url, body: body);
      var data = json.decode(response.body);
      bool status = data['status'] == 'true';
      String message = data['data']['message'];
      if (message != null) {
        return message;
      }
      String errorcode = data['errorcode'];
      return errorcode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  List<DeliveryChargeClass> getDeliveryPrice() => _deliveryCharges;

  getDeliveryDistance() => _distance;

  getParcelWeight() => _weight;

  getTotalAmount() => _totalAmount;

  getPickupLocation() => _pickupText;

  getDropLocation() => _dropText;

  getReceiverName() => _cname;

  getReceiverPhone() => _cphone;

  getRoundTrip() => _roundTrip;

  getDelInstruction() => _delInstruction;

  isFetchingDeliveryPrice() => _fetchingDeliveryPrice;

  alreadySent() => _alreadySent;
}
