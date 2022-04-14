import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/pages/vendordetails/VendorInformation.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/not_vendor_animation_service.dart';
import 'package:provider/provider.dart';

class NotVendorOrderPage extends StatefulWidget {
  const NotVendorOrderPage({Key key}) : super(key: key);

  @override
  _NotVendorOrderPageState createState() => _NotVendorOrderPageState();
}

class _NotVendorOrderPageState extends State<NotVendorOrderPage>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 50).animate(_controller)
      ..addListener(() {
        Provider.of<NotVendorAnimationService>(context, listen: false)
            .setValue(_animation.value);
      });
    _controller.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              "assets/app6.png",
              fit: BoxFit.cover,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => VendorInformation()));
              },
              child: Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<NotVendorAnimationService>(
                          builder: (context, snapshot, child) {
                        return SizedBox(
                          height: snapshot.getvalue(),
                        );
                      }),
                      Text(
                        "Register Here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: MyColors.color1),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: MyColors.color1,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
