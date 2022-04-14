import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter/DataClasses/ListOfPackageContent.dart';
import 'package:localport_alter/DataClasses/PackageContent.dart';
import 'package:localport_alter/DataClasses/SearchLocalityClass.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/pages/AddressUi/LocalitySearchPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/resources/Strings.dart';
import 'package:localport_alter/services/ApiServices/localport_order_place_service.dart';
import 'package:localport_alter/services/deliveryType_neworderpage_service.dart';
import 'package:localport_alter/services/distance_api_service.dart';
import 'package:localport_alter/services/new_order_address_service.dart';
import 'package:localport_alter/services/new_orderpage_round_trip_service.dart';
import 'package:localport_alter/services/package_content_service.dart';
import 'package:localport_alter/services/package_content_text_servic.dart';
import 'package:localport_alter/services/package_weight_text_service.dart';
import 'package:localport_alter/services/receiver_contact_service.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';
import 'package:localport_alter/widgets/AppbarWallet.dart';
import 'package:localport_alter/widgets/NotVendorNewOrderPage.dart';
import 'package:provider/provider.dart';

import 'OrderConfirmationScreen.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class NewOrder extends StatefulWidget {
  @override
  NewOrderState createState() => NewOrderState();
}

class NewOrderState extends State<NewOrder> {
  //-----------VARIABLES/ DECLARATIONS---------------
  BoxDecoration unselectedDeliveryTypeDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      boxShadow: [
        BoxShadow(
            color: MyColors.color2.withOpacity(0.3),
            offset: Offset(0, 0),
            blurRadius: 3)
      ]);
  BoxDecoration selectedDeliveryTypeDecoration = BoxDecoration(
      color: MyColors.color1, borderRadius: BorderRadius.circular(9));
  Color selectDeliveryTypeTextColor = Colors.white;
  Color unselectDeliveryTypeTextColor = MyColors.colorDark;

  TextEditingController _packageContains = TextEditingController();
  TextEditingController _packageWeight = TextEditingController();
  TextEditingController _ppackageWeight = TextEditingController();
  TextEditingController _ppackageAmt = TextEditingController();
  TextEditingController _customerPhone = TextEditingController();
  TextEditingController _customerName = TextEditingController();
  TextEditingController _pDelInstruction = TextEditingController();
  TextEditingController _bDelInstruction = TextEditingController();

  onSubmitFunction() async {
    openProcessingDialog(context);
    bool business = Provider.of<DeliveryTypeOrderPage>(context, listen: false)
        .getDeliveryType();
    String packageWeight =
        Provider.of<PackageWeightTextService>(context, listen: false).getText();
    String cphone = _customerPhone.text;
    String cname = _customerName.text;
    String distance;
    String pickuptext;
    String droptext;
    String id;
    String delInstruction;
    bool roundTrip;
    Map<String, String> pickupLatLng = {};
    Map<String, String> dropLatLng = {};
    String uid = await SharedPreferencesClass().getUid();
    final newOrderAddressService =
        Provider.of<NewOrderAddressService>(context, listen: false);
    if (business) {
      id = await SharedPreferencesClass().getVid();

      SearchLocalityClass pickupAddress =
          newOrderAddressService.getAddress()[2];
      if (pickupAddress.main_text == null ||
          pickupAddress.main_text == "null") {
        Navigator.pop(context);
        showFailMessage(selectPickupAddress);
        return;
      }

      SearchLocalityClass dropAddress = newOrderAddressService.getAddress()[3];
      if (dropAddress.main_text == null || dropAddress.main_text == "null") {
        Navigator.pop(context);
        showFailMessage(selectDropAddress);
        return;
      }

      pickuptext = pickupAddress.main_text + ',' + pickupAddress.secondary_text;
      droptext = dropAddress.main_text + ',' + dropAddress.secondary_text;

      pickupLatLng = {
        'lat': pickupAddress.lat.toString(),
        'long': pickupAddress.long.toString()
      };
      dropLatLng = {
        'lat': dropAddress.lat.toString(),
        'long': dropAddress.long.toString()
      };

      //CALCULATING DISTANCE BETWEEN PICKUP AND DROP
      distance = num.parse(
              (await findDistance(pickupLatLng, dropLatLng) / 1000).toString())
          .toStringAsPrecision(3);
      delInstruction = _bDelInstruction.text;
    } else {
      id = await SharedPreferencesClass().getUid();
      SearchLocalityClass pickupAddress =
          newOrderAddressService.getAddress()[0];
      if (pickupAddress.main_text == null ||
          pickupAddress.main_text == "null") {
        Navigator.pop(context);
        showFailMessage(selectPickupAddress);
        return;
      }

      SearchLocalityClass dropAddress = newOrderAddressService.getAddress()[1];
      if (dropAddress.main_text == null || dropAddress.main_text == "null") {
        Navigator.pop(context);
        showFailMessage(selectDropAddress);
        return;
      }
      pickuptext = pickupAddress.main_text + ',' + pickupAddress.secondary_text;
      droptext = dropAddress.main_text + ',' + dropAddress.secondary_text;

      pickupLatLng = {
        'lat': pickupAddress.lat.toString(),
        'long': pickupAddress.long.toString()
      };
      dropLatLng = {
        'lat': dropAddress.lat.toString(),
        'long': dropAddress.long.toString()
      };

      //CALCULATING DISTANCE BETWEEN PICKUP AND DROP
      distance = num.parse(
              (await findDistance(pickupLatLng, dropLatLng) / 1000).toString())
          .toStringAsPrecision(3);
      delInstruction = _pDelInstruction.text;
    }

    roundTrip =
        Provider.of<NewOrderPageRoundTripService>(context, listen: false)
            .getRoundTrip();

    if (id == null || id == "null") {
      showFailMessage(invalidUser);
      Navigator.pop(context);
      return;
    }
    if (pickuptext == null || pickuptext == "null") {
      showFailMessage(selectPickupAddress);
      Navigator.pop(context);
      return;
    }
    if (droptext == null || droptext == "null") {
      showFailMessage(selectDropAddress);
      Navigator.pop(context);
      return;
    }
    if (cname == null || cname == "null" || cname == "") {
      showFailMessage(enterReceiverName);
      Navigator.pop(context);
      return;
    }
    if (cphone == null || cphone == "null" || cphone == "") {
      showFailMessage(enterReceiverPhone);
      Navigator.pop(context);
      return;
    }
    if (delInstruction == null ||
        delInstruction == "null" ||
        delInstruction == "") {
      showFailMessage(enterDeliveryInstructions);
      Navigator.pop(context);
      return;
    }
    if (packageWeight == null ||
        packageWeight == "null" ||
        packageWeight == "") {
      showFailMessage(selectPackageWeight);
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context);

    Provider.of<localportOrderPlaceService>(context, listen: false).setData(
        business,
        id,
        pickuptext,
        droptext,
        packageWeight,
        cname,
        cphone,
        distance,
        pickupLatLng.toString(),
        dropLatLng.toString(),
        delInstruction,
        uid,
        roundTrip);

    Navigator.push(context, fadePageRoute(context, OrderConfirmationScreen()));

    // String pickuptext;
    // String dropText;
    // String id;
    //distance between pickup and drop location(approx)
    // String pickupId;
    // String dropId;
    //
    // final newOrderAddressService =
    //     Provider.of<NewOrderAddressService>(context, listen: false);
    //
    // if (business) {
    //   Map<String, String> pickupLatLng = {};
    //   Map<String, String> dropLatLng = {};
    //   UserAddressClass _pickclass = newOrderAddressService.getAddress()[2];
    //   SearchLocalityClass _dropclass =
    //       newOrderAddressService.getAddress();
    //   pickupLatLng = {'lat': _pickclass.lat, 'long': _pickclass.long};
    //   dropLatLng = {
    //     'lat': _dropclass.lat.toString(),
    //     'long': _dropclass.long.toString()
    //   };
    //
    //   //CALCULATING DISTANCE BETWEEN PICKUP AND DROP
    //   distance = num.parse(
    //           (await findDistance(pickupLatLng, dropLatLng) / 1000).toString())
    //       .toStringAsPrecision(3);
    //   pickuptext = _pickclass.belongsTo.toLowerCase() != 'self'
    //       ? _pickclass.belongsToName
    //       : _pickclass.type +
    //           " | " +
    //           _pickclass.type +
    //           " | " +
    //           _pickclass.primary_loc;
    //   dropText = '${_dropclass.main_text}, ${_dropclass.secondary_text}';
    //   pickupId = _pickclass.aid;
    //   id = await SharedPreferencesClass().getVid();
    //   dropId = _dropclass.main_text + " " + _dropclass.secondary_text;
    // } else {
    //   Map<String, String> pickupLatLng = {};
    //   Map<String, String> dropLatLng = {};
    //   UserAddressClass _pickclass = newOrderAddressService.getAddress()[0];
    //   UserAddressClass _dropclass = newOrderAddressService.getAddress()[1];
    //
    //   if (_pickclass.aid == _dropclass.aid) {
    //     showFailMessage("Drop address can't be same as pickup address");
    //     Navigator.pop(context);
    //     return;
    //   }
    //
    //   pickupLatLng = {'lat': _pickclass.lat, 'long': _pickclass.long};
    //   dropLatLng = {'lat': _dropclass.lat, 'long': _dropclass.long};
    //
    //   //CALCULATING DISTANCE BETWEEN PICKUP AND DROP
    //   distance = num.parse(
    //           (await findDistance(pickupLatLng, dropLatLng) / 1000).toString())
    //       .toStringAsPrecision(3);
    //
    //   pickuptext = _pickclass.belongsTo.toLowerCase() != 'self'
    //       ? _pickclass.belongsToName
    //       : _pickclass.type +
    //           " | " +
    //           _pickclass.type +
    //           " | " +
    //           _pickclass.primary_loc;
    //   dropText = (_dropclass.belongsTo.toLowerCase() != 'self'
    //           ? _dropclass.belongsToName
    //           : _dropclass.type) +
    //       " | " +
    //       _dropclass.type +
    //       " | " +
    //       _dropclass.primary_loc;
    //   id = await SharedPreferencesClass().getUid();
    //   pickupId = _pickclass.aid;
    //   dropId = _dropclass.aid;
    // }
    //
    // Navigator.pop(context);
    //
    // Provider.of<localportOrderPlaceService>(context, listen: false).setData(
    //     business,
    //     id,
    //     pickuptext,
    //     dropText,
    //     packageContent,
    //     packageWeight,
    //     packageValue,
    //     cphone,
    //     distance,
    //     pickupId,
    //     dropId);
    //
    // // //------------------------------------
    // //
    // Navigator.push(context,
    //     CupertinoPageRoute(builder: (context) => OrderConfirmationScreen()));
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

//----------FUNCTIONS------------------------

  Widget appBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: MyColors.color1,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
        child: Text(
          "Send Package",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget submitButton() {
    return GestureDetector(
      onTap: () {
        onSubmitFunction();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: MyColors.colorDark,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.00),
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget deliveryType() {
    return Consumer<DeliveryTypeOrderPage>(builder: (context, snapshot, child) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    snapshot.setDelType(false);
                  },
                  child: Container(
                    decoration: snapshot.getDeliveryType()
                        ? unselectedDeliveryTypeDecoration
                        : selectedDeliveryTypeDecoration,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Personal",
                          style: TextStyle(
                            color: snapshot.getDeliveryType()
                                ? unselectDeliveryTypeTextColor
                                : selectDeliveryTypeTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    snapshot.setDelType(true);
                  },
                  child: Container(
                    decoration: snapshot.getDeliveryType()
                        ? selectedDeliveryTypeDecoration
                        : unselectedDeliveryTypeDecoration,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Business",
                          style: TextStyle(
                            color: snapshot.getDeliveryType()
                                ? selectDeliveryTypeTextColor
                                : unselectDeliveryTypeTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget packageContentBottomSheet(BuildContext context) {
    List<PackageContent> pcl = ListOfPackageContent().getPackageContentList();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer<PackageContentService>(
            builder: (context, snapshot, child) {
          List<String> selectedContents = snapshot.getSelectedContents();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Select Package Content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: pcl.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: selectedContents.contains(pcl[index].id),
                        activeColor: Colors.white,
                        checkColor: MyColors.color3,
                        selectedTileColor: MyColors.colorDark,
                        onChanged: (val) {
                          if (val) {
                            snapshot.addContent(pcl[index].id);
                          } else {
                            snapshot.removeContent(pcl[index].id);
                          }
                        },
                        title: Text(
                          pcl[index].title,
                        ),
                      );
                    }),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    _packageContains.clear();
                    List<PackageContent> list =
                        ListOfPackageContent().getPackageContentList();
                    List<String> sList = snapshot.getSelectedContents();

                    list.forEach((element) {
                      if (sList.contains(element.id)) {
                        if (_packageContains.text.isEmpty) {
                          _packageContains.text =
                              _packageContains.text + "${element.title}";
                        } else {
                          _packageContains.text =
                              _packageContains.text + ", ${element.title}";
                        }
                      }
                    });
                    Provider.of<PackageContentTextService>(context,
                            listen: false)
                        .setText(_packageContains.text);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: MyColors.color1),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                )
              ]);
        }),
      ),
    );
  }

  Widget packageWeightBottomSheet(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Select Package Weight",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              ListTile(
                onTap: () {
                  Provider.of<PackageWeightTextService>(context, listen: false)
                      .setText("Upto 25 KG");
                  Navigator.pop(context);
                },
                title: Text(
                  "Upto 25 KG",
                  style: TextStyle(),
                ),
              ),
              ListTile(
                onTap: () {
                  Provider.of<PackageWeightTextService>(context, listen: false)
                      .setText("Upto 50 KG");
                  Navigator.pop(context);
                },
                title: Text(
                  "Upto 50 KG",
                  style: TextStyle(),
                ),
              ),
              ListTile(
                onTap: () {
                  Provider.of<PackageWeightTextService>(context, listen: false)
                      .setText("Upto 100 KG");
                  Navigator.pop(context);
                },
                title: Text(
                  "Upto 100 KG",
                  style: TextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget packageValueBottomSheet(context) {
    GlobalKey<FormState> _valueFormKey = GlobalKey();

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Enter Package Value",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Form(
                  key: _valueFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          controller: _ppackageAmt,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter package value";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter package value...",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_valueFormKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: MyColors.color1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget customerPhoneBottomSheet(context) {
    GlobalKey<FormState> _phoneFormKey = GlobalKey();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Enter receiver's phone number",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Form(
                  key: _phoneFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          controller: _customerPhone,
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter receiver's phone number";
                            }
                            if (val.length != 10) {
                              return "Enter correct phone number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter receiver's phone number...",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_phoneFormKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: MyColors.color1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget customerNameBottomSheet(context) {
    GlobalKey<FormState> _nameFormKey = GlobalKey();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Enter receiver's name",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Form(
                  key: _nameFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          controller: _customerName,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter receiver's name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter receiver's name...",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_nameFormKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: MyColors.color1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget personalDeliveryInstructionBottomSheet(context) {
    GlobalKey<FormState> _pDelInstFormKey = GlobalKey();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Enter delivery instruction or landmark",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Form(
                  key: _pDelInstFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          controller: _pDelInstruction,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          minLines: 5,
                          maxLines: 10,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter delivery instruction or landmark";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter delivery instruction or landmark",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_pDelInstFormKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: MyColors.color1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget businessDeliveryInstructionBottomSheet(context) {
    GlobalKey<FormState> _bDelInstFormKey = GlobalKey();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Enter delivery instruction or landmark",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Form(
                  key: _bDelInstFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          controller: _bDelInstruction,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          minLines: 5,
                          maxLines: 10,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter delivery instruction or landmark";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter delivery instruction or landmark",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_bDelInstFormKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: MyColors.color1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  activeBusinessBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pickup Address",
              style: TextStyle(),
            ),
            Consumer<NewOrderAddressService>(
                builder: (context, snapshot, child) {
              List<SearchLocalityClass> data = snapshot.getAddress();
              SearchLocalityClass add;
              if (data[2] != null) {
                add = data[2];
              }
              return ListTile(
                leading: Icon(
                  Icons.my_location,
                  color: Colors.green,
                ),
                title: Text(
                  add.main_text == null ? "" : add.main_text.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  add.main_text == null
                      ? "Please select location"
                      : add.secondary_text.toString(),
                  style: TextStyle(),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context, fadePageRoute(context, LocalitySearchPage()));
                    if (result != null) {
                      Provider.of<NewOrderAddressService>(context,
                              listen: false)
                          .setBDropLocation(2, result);
                    }
                  },
                  child: Text(
                    "Select",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.dashed,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 15,
            ),
            Text(
              "Drop Location",
              style: TextStyle(),
            ),
            Consumer<NewOrderAddressService>(
                builder: (context, snapshot, child) {
              List<SearchLocalityClass> data = snapshot.getAddress();
              SearchLocalityClass add;
              if (data[3] != null) {
                add = data[3];
              }

              return ListTile(
                leading: Icon(
                  Icons.my_location,
                  color: Colors.green,
                ),
                title: Text(
                  add.main_text == null ? "" : add.main_text.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  add.main_text == null
                      ? "Please select location"
                      : add.secondary_text.toString(),
                  style: TextStyle(),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    SearchLocalityClass result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LocalitySearchPage()));
                    if (result != null) {
                      Provider.of<NewOrderAddressService>(context,
                              listen: false)
                          .setBDropLocation(3, result);
                    }
                  },
                  child: Text(
                    "Select",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.dashed,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 15,
            ),
            Consumer<NewOrderPageRoundTripService>(
                builder: (context, snapshot, child) {
              return Row(
                children: [
                  Checkbox(
                    value: snapshot.getRoundTrip(),
                    onChanged: (val) {
                      snapshot.setRoundTrip(val);
                    },
                    activeColor: MyColors.color3,
                  ),
                  Text(
                    "Round trip",
                    style: TextStyle(),
                  ),
                ],
              );
            }),
            SizedBox(
              height: 15,
            ),
            Text(
              "Receiver's Name",
              style: TextStyle(),
            ),
            ListTile(
              onTap: () {
                Dialog dialog = Dialog(
                  child: customerNameBottomSheet(context),
                );
                showDialog(context: context, builder: (context) => dialog);
              },
              leading: Icon(
                CupertinoIcons.briefcase,
                color: Colors.green,
              ),
              title: TextFormField(
                enabled: false,
                controller: _customerName,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter receiver's name"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Receiver's phone number",
              style: TextStyle(),
            ),
            ListTile(
              onTap: () {
                Dialog dialog = Dialog(
                  child: customerPhoneBottomSheet(context),
                );
                showDialog(context: context, builder: (context) => dialog);
              },
              leading: Icon(
                CupertinoIcons.briefcase,
                color: Colors.green,
              ),
              title: TextFormField(
                enabled: false,
                controller: _customerPhone,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter receiver's phone number"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Delivery instruction/Landmark",
              style: TextStyle(),
            ),
            ListTile(
              onTap: () {
                Dialog dialog = Dialog(
                  child: businessDeliveryInstructionBottomSheet(context),
                );
                showDialog(context: context, builder: (context) => dialog);
              },
              leading: Icon(
                CupertinoIcons.briefcase,
                color: Colors.green,
              ),
              title: TextFormField(
                enabled: false,
                controller: _bDelInstruction,
                keyboardType: TextInputType.text,
                minLines: 1,
                maxLines: 10,
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter delivery instruction or landmark"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Select Package Weight",
              style: TextStyle(),
            ),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: packageWeightBottomSheet);
              },
              leading: Icon(
                CupertinoIcons.archivebox,
                color: Colors.green,
              ),
              title: Consumer<PackageWeightTextService>(
                  builder: (context, snapshot, child) {
                _packageWeight.text = snapshot.getText();
                return TextField(
                  controller: _packageWeight,
                  enabled: false,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Select Package Weight"),
                );
              }),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            submitButton()
          ],
        ),
      ),
    );
  }

  // selectContact(bool vendor) async {
  //   Contact contact = await ContactPicker().selectContact();
  //   String num = contact.phoneNumber.number;
  //   num = num.replaceAll("(", '');
  //   num = num.replaceAll(")", '');
  //   num = num.replaceAll(" ", '');
  //   num = num.replaceAll("-", '');
  //   print(num);
  //   Provider.of<ReceiverContactService>(context, listen: false)
  //       .setContactDetails({"name": contact.fullName, "number": num}, vendor);
  // }

  personalReceiverDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Receiver's Name",
          style: TextStyle(),
        ),
        ListTile(
          onTap: () {
            Dialog dialog = Dialog(
              child: customerNameBottomSheet(context),
            );
            showDialog(context: context, builder: (context) => dialog);
          },
          leading: Icon(
            CupertinoIcons.briefcase,
            color: Colors.green,
          ),
          title: TextFormField(
            enabled: false,
            controller: _customerName,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Enter receiver's name"),
          ),
          // trailing: GestureDetector(
          //   onTap: () {
          //     selectContact();
          //   },
          //   child: Icon(
          //     Icons.contacts,
          //     color: Colors.green,
          //   ),
          // ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Receiver's phone number",
          style: TextStyle(),
        ),
        ListTile(
          onTap: () {
            Dialog dialog = Dialog(
              child: customerPhoneBottomSheet(context),
            );
            showDialog(context: context, builder: (context) => dialog);
          },
          leading: Icon(
            CupertinoIcons.briefcase,
            color: Colors.green,
          ),
          title: TextFormField(
            enabled: false,
            controller: _customerPhone,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Enter receiver's phone number"),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  personalBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pickup Address",
              style: TextStyle(),
            ),
            Consumer<NewOrderAddressService>(
                builder: (context, snapshot, child) {
              List<SearchLocalityClass> data = snapshot.getAddress();
              SearchLocalityClass add;
              if (data[0] != null) {
                add = data[0];
              }
              return ListTile(
                leading: Icon(
                  Icons.my_location,
                  color: Colors.green,
                ),
                title: Text(
                  add.main_text == null ? "" : add.main_text.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  add.main_text == null
                      ? "Please select location"
                      : add.secondary_text.toString(),
                  style: TextStyle(),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LocalitySearchPage()));
                    if (result != null) {
                      Provider.of<NewOrderAddressService>(context,
                              listen: false)
                          .setBDropLocation(0, result);
                    }
                  },
                  child: Text(
                    "Select",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.dashed,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 15,
            ),
            Text(
              "Drop Location",
              style: TextStyle(),
            ),
            Consumer<NewOrderAddressService>(
                builder: (context, snapshot, child) {
              List<SearchLocalityClass> data = snapshot.getAddress();
              SearchLocalityClass add;
              if (data[1] != null) {
                add = data[1];
              }
              return ListTile(
                leading: Icon(
                  Icons.my_location,
                  color: Colors.green,
                ),
                title: Row(
                  children: [
                    Text(
                      add.main_text == null ? "" : add.main_text.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Text(
                  add.main_text == null
                      ? "Please select location"
                      : add.secondary_text.toString(),
                  style: TextStyle(),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LocalitySearchPage()));
                    if (result != null) {
                      Provider.of<NewOrderAddressService>(context,
                              listen: false)
                          .setBDropLocation(1, result);
                    }
                  },
                  child: Text(
                    "Select",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.dashed,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 15,
            ),
            Consumer<NewOrderPageRoundTripService>(
                builder: (context, snapshot, child) {
              return Row(
                children: [
                  Checkbox(
                    value: snapshot.getRoundTrip(),
                    onChanged: (val) {
                      snapshot.setRoundTrip(val);
                    },
                    activeColor: MyColors.color3,
                  ),
                  Text(
                    "Round trip",
                    style: TextStyle(),
                  ),
                ],
              );
            }),
            SizedBox(
              height: 15,
            ),
            personalReceiverDetails(),
            Text(
              "Delivery instruction/Landmark",
              style: TextStyle(),
            ),
            ListTile(
              onTap: () {
                Dialog dialog = Dialog(
                  child: personalDeliveryInstructionBottomSheet(context),
                );
                showDialog(context: context, builder: (context) => dialog);
              },
              leading: Icon(
                CupertinoIcons.briefcase,
                color: Colors.green,
              ),
              title: TextFormField(
                enabled: false,
                controller: _pDelInstruction,
                keyboardType: TextInputType.text,
                minLines: 1,
                maxLines: 10,
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter delivery instruction or landmark"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Select Package Weight",
              style: TextStyle(),
            ),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: packageWeightBottomSheet);
              },
              leading: Icon(
                CupertinoIcons.archivebox,
                color: Colors.green,
              ),
              title: Consumer<PackageWeightTextService>(
                  builder: (context, snapshot, child) {
                _ppackageWeight.text = snapshot.getText();
                return TextField(
                  controller: _ppackageWeight,
                  enabled: false,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Select Package Weight"),
                );
              }),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            submitButton()
          ],
        ),
      ),
    );
  }

  bodySelector() {
    return Consumer<DeliveryTypeOrderPage>(builder: (context, snapshot, child) {
      bool business = snapshot.getDeliveryType();
      bool isUserVendor = snapshot.isUserAVendor();
      if (business) {
        return isUserVendor ? activeBusinessBody() : NotVendorOrderPage();
      }
      return personalBody();
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DeliveryTypeOrderPage>(context, listen: false)
        .fetchBusinessOwner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CupertinoNavigationBarBackButton(
                        color: MyColors.color1,
                      ),
                      Text(
                        "Place new order",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Expanded(child: Container()),
                      AppbarWallet()
                    ],
                  ),
                ),
              ),
              deliveryType(),
              bodySelector()
            ],
          ),
        ),
      )),
    );
  }
}
