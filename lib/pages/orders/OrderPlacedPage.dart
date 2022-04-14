import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_balance_fetch_service.dart';
import 'package:localport_alter/services/order_placed_service.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatefulWidget {
  @override
  OrderPlacedScreenState createState() => OrderPlacedScreenState();
}

class OrderPlacedScreenState extends State<OrderPlacedScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Provider.of<LocalportBalanceFetchService>(context, listen: false)
        .fetchBalance(null);
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _animation = Tween<double>(
      begin: 0,
      end: 150,
    ).animate(_animationController)
      ..addListener(() {
        Provider.of<OrderPlacedService>(context, listen: false)
            .setValue(_animation.value);
      });

    _animationController.forward();
    _animation.addStatusListener((status) async {
      if(status==AnimationStatus.completed){
        await Future.delayed(Duration(milliseconds: 500));
       Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<OrderPlacedService>(
                builder: (context, snapshot, child) {
                  return Column(
                    children: [
                      Icon(
                        Icons.done,
                        color: Colors.white,
                        size: snapshot.getValue(),
                      ),
                      Text("Order Placed", style: TextStyle(
                        color: Colors.white,
                        fontSize: snapshot.getValue()/10,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  );
                }
            ),

          ],
        ),
      ),
    );
  }
}
