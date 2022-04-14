import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/pages/Profile/ProfilePage.dart';
import 'package:localport_alter/pages/Wallet/WalletPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_balance_fetch_service.dart';
import 'package:provider/provider.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class AppbarWallet extends StatefulWidget {
  const AppbarWallet({Key key}) : super(key: key);

  @override
  _AppbarWalletState createState() => _AppbarWalletState();
}

class _AppbarWalletState extends State<AppbarWallet> {

  @override
  void initState() {
    super.initState();
    Provider.of<LocalportBalanceFetchService>(context, listen: false)
        .fetchBalance(null);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, fadePageRoute(context, ProfilePage()));
        },
        child: Consumer<LocalportBalanceFetchService>(
          builder: (context, snapshot, child) {
            return Container(
              decoration: BoxDecoration(
                  color: MyColors.color2.withAlpha(60),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: MyColors.color1,
                    ),
                    RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                            children: [
                              TextSpan(text: "Rs. "),
                              TextSpan(text: snapshot.getWallet())
                            ])),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[500],
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
