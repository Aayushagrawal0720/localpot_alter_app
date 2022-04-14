import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/pages/LandingPage.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_balance_fetch_service.dart';
import 'package:localport_alter/services/ApiServices/localport_money_add_service.dart';
import 'package:localport_alter/services/add_money_page_service.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AmountPage extends StatefulWidget {
  const AmountPage({Key key}) : super(key: key);

  @override
  _AmountPageState createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  TextEditingController _amountController = TextEditingController();
  var _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // _razorpay.clear();
    Provider.of<LocalportMoneyAddService>(context, listen: false)
        .addMoneyToWallet(
            await SharedPreferencesClass().getUid(),
            _amountController.text,
            "Success",
            "wallet",
            "Bank",
            {
              "razorpay_payment_id": response.paymentId,
              "razorpay_order_id": response.orderId,
              "razorpay_signature": response.signature
            }.toString())
        .then((value) {
      if (value) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Success!!!",
            title: "Balance Updated Successfully",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Provider.of<LocalportBalanceFetchService>(context, listen: false)
                  .fetchBalance(null);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     CupertinoPageRoute(builder: (context) => LandingPage()),
              //         (Route<dynamic> route) => false);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => MyHomePage()));
            });
      } else {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "Failed!",
            title: "Failed To Update Balance",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pop(context);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => MyHomePage()));
            });
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _razorpay.clear();
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed!!!",
          title: "Payment Cancelled By User",
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => MyHomePage()));
          });
    }
    if (response.code == Razorpay.NETWORK_ERROR) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed!!!",
          title: "Network Error",
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => MyHomePage()));
          });
    }
// // Do something when payment fails
  }

  startPayment() async {
    int amt = int.parse(_amountController.text.toString().split(".")[0]) * 100;
    String name = await SharedPreferencesClass().getFName() +
        " " +
        await SharedPreferencesClass().getLName();
    String phone = await SharedPreferencesClass().getPhone();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    String uid = await SharedPreferencesClass().getUid();
    var options = {
      'key': 'rzp_live_MPtZ878J7eEEXm',
      'amount': amt,
      'name': "Localport",
      "currency": "INR",
      'description': "wallet for $uid",
      'prefill': {
        'name': name,
        'contact': phone,
        // 'email': Provider.of<ProfileInfoServices>(context, listen: false)
        //     .getemail()
        //     .toString(),
      },
    };
    _razorpay.open(options);
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
              "Add money to wallet",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  _amountChips() {
    List<double> _amounts = [200, 500, 1000, 2000];
    return Container(
      height: 50,
      child: ListView.builder(
        itemCount: _amounts.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Provider.of<AddMoneyPageService>(context, listen: false)
                    .setAmount(_amounts[index]);
              },
              child: Chip(
                label: Text(_amounts[index].toString()),
              ),
            ),
          );
        },
      ),
    );
  }

  _proceedToPayButton() {
    return GestureDetector(
      onTap: startPayment,
      // onTap: (){
      //   _handlePaymentSuccess(null);
      // },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: MyColors.color3, borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                "Proceed to pay",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _amountSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 0),
              blurRadius: 12)
        ]),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(text: "Available cash: "),
                    TextSpan(
                        text: Provider.of<LocalportBalanceFetchService>(context,
                            listen: false).getWallet().toString())
                  ])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              // onChanged: (val){
              //   snapshot.setAmount(double.parse(val));
              // },
              controller: _amountController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: MyColors.color1,
                      )),
                  hintText: "Enter amount",
                  label: Text(
                    "Enter amount",
                    style: TextStyle(color: MyColors.color1),
                  )),
            )
          ),
          // _amountChips(),
          _proceedToPayButton()
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [_appBar(), _amountSection()],
            ),
          ),
        ),
      ),
    );
  }
}
