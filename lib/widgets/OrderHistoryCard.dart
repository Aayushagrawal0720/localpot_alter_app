import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/pages/orders/OrderConfirmationScreen.dart';
import 'package:localport_alter/pages/orders/OrderDetailPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/resources/Strings.dart';
import 'package:localport_alter/services/ApiServices/localport_order_detail_service.dart';
import 'package:localport_alter/services/ApiServices/localport_order_place_service.dart';
import 'package:localport_alter/services/order_history_page_service.dart';
import 'package:provider/provider.dart';
import 'AppDialogs.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class OrderHistoryCard extends StatefulWidget {
  OrderHistoryObjectClass _historyObjectClass = OrderHistoryObjectClass();

  OrderHistoryCard(this._historyObjectClass);

  @override
  _OrderHistoryCardState createState() =>
      _OrderHistoryCardState(_historyObjectClass);
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  OrderHistoryObjectClass _historyObjectClass = OrderHistoryObjectClass();

  _OrderHistoryCardState(this._historyObjectClass);

  repeatOrderFunction() async {
    openProcessingDialog(context);
    bool business = Provider.of<OrderHistoryPageService>(context, listen: false)
                .getOrderHistorySearchType() ==
            'Individual'
        ? false
        : true;
    String packageWeight = _historyObjectClass.weight;
    String cphone = _historyObjectClass.rPhone;
    String cname = _historyObjectClass.rName;
    String distance = _historyObjectClass.distance;
    String pickuptext = _historyObjectClass.pickutext;
    String droptext = _historyObjectClass.dropText;
    String id = _historyObjectClass.id;
    String delInstruction = _historyObjectClass.delInstruction;
    bool roundTrip = _historyObjectClass.roundTrip == null
        ? false
        : _historyObjectClass.roundTrip;
    String uid = await SharedPreferencesClass().getUid();
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
        null,
        null,
        delInstruction,
        uid,
        roundTrip);

    Navigator.push(context,
        fadePageRoute(context, OrderConfirmationScreen()));
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  showVendorDialog(String status) {
    var dialog = Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              status == 'Pending' ? "Very soon..." : "On The Way...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Text(
              status == 'Pending'
                  ? "A delivery partner will be assigned soon"
                  : "A delivery partner will be at your location in no time",
              style: TextStyle(color: MyColors.fontgrey),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.color1,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
    showCupertinoDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<LocalportOrderDetailsServce>(context, listen: false)
              .setOrder(widget._historyObjectClass);
          Navigator.push(context,
              fadePageRoute(context, OrderDetailPage()));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                width: 0.05,
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(
                      0,
                      0,
                    ))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.withAlpha(25),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget._historyObjectClass.rName,
                            maxLines: 3,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            widget._historyObjectClass.dropText.split(",")[0],
                            maxLines: 5,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Container(
                        color: Colors.grey.withAlpha(60),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget._historyObjectClass.status,
                            overflow: TextOverflow.visible,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pickup",
                          style: TextStyle(
                              color: MyColors.fontgrey, fontSize: 12),
                        ),
                        Text(
                          widget._historyObjectClass.pickutext.split(",")[0],
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        // widget._historyObjectClass.resamt==null? Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Value",
                        //       style: TextStyle(
                        //           color: MyColors.fontgrey, fontSize: 12),
                        //     ),
                        //     Text(
                        //       widget._historyObjectClass.resamt,
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ):Container(),
                      ],
                    ),
                    Expanded(child: Container()),
                    widget._historyObjectClass.roundTrip
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow:[
                                BoxShadow(
                                  color: Colors.grey.withAlpha(35),
                                  offset: Offset(0, 0),
                                  blurRadius: 3
                                )
                              ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Round trip",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 5, bottom: 5),
                child: Divider(
                  height: 1,
                  color: MyColors.fontgrey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      widget._historyObjectClass.weight + " KG",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget._historyObjectClass.distance + " KM",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat("dd-MM-yyy hh:mm").format(widget._historyObjectClass.date),
                      style: TextStyle(
                        color: MyColors.fontgrey,
                      ),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: repeatOrderFunction,
                      child: Container(
                        color: MyColors.color1.withAlpha(25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 18,
                              ),
                              Text(" repeat order")
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
