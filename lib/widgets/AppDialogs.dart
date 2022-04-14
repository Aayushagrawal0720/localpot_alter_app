import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/pages/Wallet/AmountPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_invoice_download_service.dart';
import 'package:localport_alter/services/location_locality_service.dart';
import 'package:provider/provider.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

PermissionDialogue(BuildContext context) async {
  await Future.delayed(Duration(milliseconds: 200));
  Dialog dialog = Dialog(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Permission Denied",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "Please enable location for application in device setting.",
            style: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.color1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );

  showDialog(context: context, builder: (context) => dialog);
}

openProcessingDialog(BuildContext context) {
  var dialog = Dialog(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 0))
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: SpinKitSquareCircle(
        color: MyColors.color1,
        size: 28,
      ),
    ),
  );
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return dialog;
      });
}

enableLocationServiceDialog(BuildContext context) {
  var dialog = Dialog(
      elevation: 3,
      child: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 0))
              ],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enable location service use this application",
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: MyColors.greyWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: MyColors.greyWhite,
                                offset: Offset(0, 0),
                                blurRadius: 6)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () async {
                            if (await Geolocator.isLocationServiceEnabled()) {
                              Provider.of<LocationLocalityService>(context,
                                      listen: false)
                                  .fetchLocality(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Try again",
                            style: TextStyle(color: MyColors.color3),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: MyColors.color3,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: MyColors.greyWhite,
                                offset: Offset(0, 0),
                                blurRadius: 6)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () async {
                            Geolocator.openLocationSettings();
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ));

  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return dialog;
      });
}

insufficientBalanceDialog(BuildContext context) {
  Dialog dialog = Dialog(
    elevation: 3,
    child: Container(
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Insufficient wallet balance",
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "You don't have sufficient balance to place this order",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         border: Border.all(color: Colors.black),
                //         borderRadius: BorderRadius.circular(3)),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 8, horizontal: 14),
                //       child: Text(
                //         "Cancel",
                //         style: TextStyle(color: Colors.black),
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        fadePageRoute(context, AmountPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.color1,
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      child: Text(
                        "Add balance",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ),
  );

  showDialog(context: context, builder: (context) => dialog);
}

showPriorityUpdateDialog(BuildContext context) {
  Dialog dialog = Dialog(
    child: Container(
      height: MediaQuery.of(context).size.height-100,
      width: MediaQuery.of(context).size.width-20,

    ),
  );
  showDialog(
      context: context,
      builder: (context) => dialog,
      barrierDismissible: false);
}

showUpdateDialog(BuildContext context) {
  Dialog dialog = Dialog(
  );
  showDialog(
      context: context,
      builder: (context) => dialog,
      barrierDismissible: false);
}

showInvoiceDialog(BuildContext context){
  Dialog dialog = Dialog(
    child: Consumer<LocalportInvoiceDownloadService>(
      builder: (context, snapshot, child) {
        if(!snapshot.isDownloading()){
          Navigator.pop(context);
        }
        return Container(
          height: MediaQuery.of(context).size.height/6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SpinKitChasingDots(color: MyColors.color3,),
                Text(snapshot.isCreating()?'preparing invoice...':'downloading invoice...')
              ],
            ),
          ),
        );
      }
    ),
  );

  showDialog(
      context: context,
      builder: (context) => dialog,
      barrierDismissible: false);
}
