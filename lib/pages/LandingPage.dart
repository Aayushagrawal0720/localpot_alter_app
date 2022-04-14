import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/pages/ondemand/ondemand.dart';
import 'package:localport_alter/pages/update/update_page.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/resources/ServerConstants.dart';
import 'package:localport_alter/services/ApiServices/localport_homepage_service.dart';
import 'package:localport_alter/services/ApiServices/localport_notitoken_service.dart';
import 'package:localport_alter/services/ApiServices/localport_user_verification_service.dart';
import 'package:localport_alter/services/notification/firebase_notification_services.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';
import 'package:localport_alter/widgets/AppbarWallet.dart';
import 'package:localport_alter/widgets/Skeletons/LandingPageSkeleton.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'Profile/ProfilePage.dart';
import 'authentication/SigninScreen.dart';
import 'orders/NewOrderPage.dart';
import 'orders/OrderHistory.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  List<String> _images = [];

  Widget greetings(String name) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 12,
      ),
      child: Row(
        children: [
          Container(
            child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    style: GoogleFonts.koHo(
                        color: MyColors.colorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                    children: [
                      TextSpan(text: "Hi "),
                      TextSpan(text: name),
                      TextSpan(text: ","),
                    ])),
          ),
          Expanded(child: Container()),
          AppbarWallet(),
          GestureDetector(
            onTap: () {
              Navigator.push(context, fadePageRoute(context, ProfilePage()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                  radius: 13,
                  backgroundColor: MyColors.colorDark,
                  child: Icon(Icons.person)),
            ),
          )
        ],
      ),
    );
  }

  Widget sendAPackageButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadePageRoute(context, NewOrder()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [MyColors.color1, MyColors.color3], stops: [0.3, 0.7]),
            borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Send a package",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    Text(
                      "Get your package delivered in few clicks",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.black.withAlpha(99),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Image.asset(
                "assets/images/del_boy.png",
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                fit: BoxFit.fill,
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget demandButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadePageRoute(context, OnDemandPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurple.withAlpha(700)],
                stops: [0.3, 0.7]),
            borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Demand box",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    Text(
                      "No need to step out of your home, tell us we will bring everything for you",
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.white.withAlpha(99),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Image.asset(
                "assets/images/lp_ondemand.png",
                width: MediaQuery.of(context).size.width / 6 - 15,
                height: MediaQuery.of(context).size.width / 6,
                fit: BoxFit.fill,
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget orderHistory() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadePageRoute(context, OrderHistory()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order History",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: MyColors.colorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Image.asset(
                "assets/images/del_boy_done.png",
                width: MediaQuery.of(context).size.width / 8,
                height: MediaQuery.of(context).size.width / 6,
                fit: BoxFit.fill,
              ),
              Expanded(child: Container()),
              CircleAvatar(
                radius: 12,
                backgroundColor: MyColors.colorDark,
                child: Center(
                  child: Icon(Icons.keyboard_arrow_right),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget slidingBanner() {
    return Consumer<LocalportHomePageService>(
        builder: (context, snapshot, child) {
      if (!snapshot.isHpLoading()) {
        _images = snapshot.getImages();
      }
      if (snapshot.getUpdate()) {
        showPriorityUpdateDialog(context);
        // if(snapshot.getHighPriority()){
        //   showPriorityUpdateDialog(context);
        // }else{
        //   showUpdateDialog(context);
        // }
      }
      return snapshot.isHpLoading()
          ? LandingPageSkeleton()
          : _images.length > 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: CarouselSlider.builder(
                      enableAutoSlider: true,
                      unlimitedMode: true,
                      autoSliderDelay: Duration(seconds: 3),
                      autoSliderTransitionTime: Duration(milliseconds: 300),
                      slideBuilder: (index) => upperBanner(_images[index]),
                      itemCount: _images.length),
                )
              : Container();
    });
  }

  Widget upperBanner(String image) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: FittedBox(
              child: Image.network(image),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyParent() {
    return Container(
      decoration: BoxDecoration(
          color: MyColors.color1.withOpacity(0.1),
          borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: <Widget>[
            sendAPackageButton(),
            SizedBox(
              height: 15,
            ),
            demandButton(),
            SizedBox(
              height: 15,
            ),
            orderHistory(),
            //Active Orders baad m banana hai
          ],
        ),
      ),
    );
  }

  checkUpdate() async {
    Provider.of<LocalportHomePageService>(context, listen: false)
        .checkUpdate()
        .then((value) async {
      if (value) {
        await Future.delayed(Duration(seconds: 3));
        // showPriorityUpdateDialog(context);
        Navigator.push(context, fadePageRoute(context, UpdatePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<localportUserVerificationService>(context, listen: false)
        .verifyUser()
        .then((result) {
      try {
        if (result.toString() == USER_NOT_FOUND) {
          Navigator.pushAndRemoveUntil(context,
              fadePageRoute(context, SigninScreen()), (route) => false);
        }
      } catch (err) {
        print(err);
      }
    });

    Provider.of<LocalportHomePageService>(context, listen: false)
        .fetchHomePage();

    // checkUpdate();
    checkForUpdate();

    FirebaseNotificationService().fetchNotificationToken().then((String token) {
      LocalportNotificationTokenService().sendToken(token);
    });
  }

  checkForUpdate() {
    InAppUpdate.checkForUpdate().then((value) {
      if (value.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate().then((value) {
          checkForUpdate();
        }).catchError((err) {
          checkForUpdate();
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: FutureBuilder<String>(
              future: SharedPreferencesClass().getFName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  String name = 'there';
                  if (snapshot.hasData) {
                    name = snapshot.data;
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [greetings(name), slidingBanner(), bodyParent()],
                  );
                }

                return Center(
                  child: SpinKitChasingDots(
                    color: Colors.green,
                  ),
                );
              })),
    );
  }
}
