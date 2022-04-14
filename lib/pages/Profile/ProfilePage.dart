import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:localport_alter/pages/TransactionHistory/TransactionHistory.dart';
import 'package:localport_alter/pages/Wallet/AmountPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_balance_fetch_service.dart';
import 'package:localport_alter/services/profile_page_service.dart';
import 'package:provider/provider.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget walletCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(0, 0),
            blurRadius: 12)
      ]),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: MyColors.color1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Available balance",
                      style: TextStyle(
                        color: MyColors.color1,
                      )),
                ],
              ),
              _walletCard(),
              _addMoneyButton()
            ],
          )),
    );
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
              "Profile",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  _walletCard() {
    return Consumer<LocalportBalanceFetchService>(
        builder: (context, snapshot, child) {
      List<Map<String, String>> _balanceList = snapshot.getBalanceData();
      bool error = snapshot.getError();

      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, fadePageRoute(context, TransactionHistory()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      "Transaction history",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
            error
                ? Text(
                    "Cannot fetch balance",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : _balanceList.length == 0
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: SpinKitChasingDots(
                          color: MyColors.color1,
                          size: 20,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _balanceList.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  _balanceList[index]
                                      .keys
                                      .first
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Container()),
                                LineIcon.indianRupeeSign(
                                  color: MyColors.color1,
                                  size: 26,
                                ),
                                Text(
                                  _balanceList[index].values.first,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          );
                        }),
          ],
        ),
      );
    });
  }

  _addMoneyButton() {
    return Row(
      children: [
        Expanded(child: Container()),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                fadePageRoute(context, AmountPage()));
          },
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.color3,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(0, 0),
                      blurRadius: 6)
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: Text(
                "Add money",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ProfilePageService>(context, listen: false).fetchProfileInfo();
    Provider.of<LocalportBalanceFetchService>(context, listen: false)
        .fetchBalance(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: RefreshIndicator(
        color: MyColors.color1,
        onRefresh: () async {
          Provider.of<LocalportBalanceFetchService>(context, listen: false)
              .fetchBalance(null);
          return true;
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _appBar(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ProfilePageService>(
                          builder: (context, snapshot, child) {
                        return snapshot.isBusiness() == null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: MyColors.color1,
                                  ),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          offset: Offset(0, 0),
                                          blurRadius: 12)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.getName(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 12,
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  offset: Offset(0, 0))
                                            ]),
                                            child: CircleAvatar(
                                              child: Icon(
                                                Icons.call,
                                                color: MyColors.color1,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            snapshot.getPhone(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 12,
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  offset: Offset(0, 0))
                                            ]),
                                            child: CircleAvatar(
                                              child: Icon(
                                                Icons.local_mall,
                                                color: MyColors.color1,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Business Owner: ${snapshot.isBusiness() ? "Yes" : "No"}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      snapshot.isBusiness()
                                          ? SizedBox(
                                              height: 15,
                                            )
                                          : Container(),
                                      snapshot.isBusiness()
                                          ? Row(
                                              children: [
                                                Container(
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 12,
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        offset: Offset(0, 0))
                                                  ]),
                                                  child: CircleAvatar(
                                                    child: Icon(
                                                      Icons.local_mall,
                                                      color: MyColors.color1,
                                                    ),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Business name: ${snapshot.getVname()}",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      walletCard()
                    ],
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
