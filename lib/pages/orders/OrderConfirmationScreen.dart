import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter/pages/Wallet/AmountPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/resources/Strings.dart';
import 'package:localport_alter/services/ApiServices/localport_balance_fetch_service.dart';
import 'package:localport_alter/services/ApiServices/localport_order_place_service.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';
import 'package:localport_alter/widgets/Skeletons/OrderConfirmationSkeleton.dart';
import 'package:provider/provider.dart';

import 'OrderPlacedPage.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class OrderConfirmationScreen extends StatefulWidget {
  @override
  OrderConfirmationScreenState createState() => OrderConfirmationScreenState();
}

class OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  fetchDeliveryChanges() {
    Provider.of<localportOrderPlaceService>(context, listen: false)
        .fetchDeliveryCharge()
        .then((value) async {
      if (value != '' && value!=null) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cannot fetch delivery charges'),
          duration: Duration(seconds: 3),
        ));
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
      }
    });
  }

  placeOrder() {
    try {
      if (!Provider.of<localportOrderPlaceService>(context, listen: false)
          .alreadySent()) {
        Provider.of<localportOrderPlaceService>(context, listen: false)
            .placeOrder()
            .then((value) {
          if (value == "") {
            Navigator.push(context,
                fadePageRoute(context, OrderPlacedScreen()));
          } else if (value == 500) {
            showFailMessage("Please try again after sometime");
          } else if (value == "Insufficient balance") {
            CoolAlert.show(
                context: context,
                type: CoolAlertType.info,
                text: "Insufficient balance",
                title: "You don't have sufficient balance to place this order",
                barrierDismissible: false,
                confirmBtnText: "Add balance",
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      fadePageRoute(context, AmountPage()));
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     CupertinoPageRoute(builder: (context) => LandingPage()),
                  //         (Route<dynamic> route) => false);
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => MyHomePage()));
                });
          }
        });
      }
    } catch (err) {
      print(err);
      showFailMessage("Please try again after sometime");
    }
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  listCard(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$key :",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 3,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDeliveryChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.color4,
        title: Text(
          "Confirm your order",
          style: TextStyle(),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<localportOrderPlaceService>(
                builder: (context, snapshot, child) {
              if (snapshot.isFetchingDeliveryPrice()) {
                return OrderConfirmationSkeleton();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listCard(parcelWeight, snapshot.getParcelWeight()),
                  listCard(pickupLocation, snapshot.getPickupLocation()),
                  listCard(dropLocation, snapshot.getDropLocation()),
                  listCard(receiverName, snapshot.getReceiverName()),
                  listCard(receiverPhone, snapshot.getReceiverPhone()),
                  listCard(roundTrip, snapshot.getRoundTrip().toString()),
                  listCard(delInstruction, snapshot.getDelInstruction()),
                  Divider(
                    thickness: 1,
                  ),
                  listCard(distance, snapshot.getDeliveryDistance()),
                  ListView.builder(
                      itemCount: snapshot.getDeliveryPrice().length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        List<DeliveryChargeClass> _list =
                            snapshot.getDeliveryPrice();
                        return listCard(_list[index].key.toString(),
                            _list[index].value.toString());
                      }),
                  Divider(
                    thickness: 1,
                  ),
                  listCard('Total', snapshot.getTotalAmount().toString()),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      placeOrder();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: MyColors.colorDark,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 0),
                                blurRadius: 6),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
