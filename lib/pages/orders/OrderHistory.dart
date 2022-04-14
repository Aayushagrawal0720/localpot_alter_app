import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/pages/invoice/invoice_page.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_order_history_services.dart';
import 'package:localport_alter/services/order_history_page_service.dart';
import 'package:localport_alter/widgets/OrderHistoryCard.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderHistoryObjectClass> _orders = [];

  fetchOrders() async {
    try {
      bool business =
          Provider.of<OrderHistoryPageService>(context, listen: false)
                      .getOrderHistorySearchType() ==
                  'Individual'
              ? false
              : true;
      String status =
          Provider.of<OrderHistoryPageService>(context, listen: false)
              .getOrderHistorySearchStatus();
      String id = business
          ? await SharedPreferencesClass().getVid()
          : await SharedPreferencesClass().getUid();

      Provider.of<localportOrderHistoryServices>(context, listen: false)
          .fetchOrders(id, business, status);
    } catch (err) {
      print(err);
      showFailMessage("Please try again after sometime");
    }
  }

  void setOrderHistoryType() async {
    bool _isVendor = await SharedPreferencesClass().getIsVendor();
    Provider.of<OrderHistoryPageService>(context, listen: false)
        .setOrderHistorySearchType(_isVendor ? 'Business' : 'Individual')
        .then((value) {
      fetchOrders();
    });
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget orderList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<localportOrderHistoryServices>(
          builder: (context, snapshot, child) {
        _orders = snapshot.getOrder();
        return snapshot.isLoading()
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: MyColors.color1,
                  ),
                ),
              )
            : _orders.length == 0
                ? Container(
                    child: Center(
                        child: Text(
                      "No record found",
                      style: TextStyle(),
                    )),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          return OrderHistoryCard(_orders[index]);
                        }),
                  );
      }),
    );
  }

  Widget historyType() {
    return Consumer<OrderHistoryPageService>(
        builder: (context, snapshot, child) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                        value: 'Individual',
                        activeColor: MyColors.color1,
                        groupValue: snapshot.getOrderHistorySearchType(),
                        onChanged: (val) {
                          snapshot.setOrderHistorySearchType(val);
                          fetchOrders();
                        }),
                    Text(
                      "Individual",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: snapshot.getOrderHistorySearchType() ==
                                  "Individual"
                              ? MyColors.color1
                              : Colors.black),
                    )
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: 'Business',
                        activeColor: MyColors.color1,
                        groupValue: snapshot.getOrderHistorySearchType(),
                        onChanged: (val) {
                          snapshot.setOrderHistorySearchType(val);
                          fetchOrders();
                        }),
                    Text(
                      "Business",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color:
                              snapshot.getOrderHistorySearchType() == "Business"
                                  ? MyColors.color1
                                  : Colors.black),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: MyColors.color1)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        elevation: 0,
                        onChanged: (val) {
                          snapshot.setStatus(val);
                          fetchOrders();
                        },
                        value: snapshot.getOrderHistorySearchStatus(),
                        items: <String>[
                          'All',
                          'Pending',
                          'Way to pick up',
                          'On the way',
                          'Delivered'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            orderList()
          ],
        ),
      );
    });
  }

  _appBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CupertinoNavigationBarBackButton(
              color: MyColors.color1,
            ),
            Text(
              "Order History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(flex: 2, child: Container()),
            GestureDetector(
              onTap: () {
                Navigator.push(context, fadePageRoute(context, InvoicePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.color1.withAlpha(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: Colors.black,
                      ),
                      Text(
                        'INVOICE',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setOrderHistoryType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: RefreshIndicator(
        color: MyColors.color1,
        onRefresh: () async {
          fetchOrders();
          return true;
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                _appBar(),
                Expanded(
                  child: RefreshIndicator(
                    color: MyColors.color1,
                    onRefresh: () async {
                      fetchOrders();
                      return true;
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: historyType()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
