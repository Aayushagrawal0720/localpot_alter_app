import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_demand_service.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';
import 'package:provider/provider.dart';

class OnDemandPage extends StatefulWidget {
  const OnDemandPage({Key key}) : super(key: key);

  @override
  _OnDemandPageState createState() => _OnDemandPageState();
}

class _OnDemandPageState extends State<OnDemandPage> {
  TextEditingController _demandBox = TextEditingController();
  GlobalKey<FormState> _demandFormKey = GlobalKey();

  onSubmitFunction() async {
    openProcessingDialog(context);
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    String uid = await SharedPreferencesClass().getUid();
    Provider.of<LocalportDemandService>(context, listen: false)
        .uploadDemandToServer(_demandBox.text, uid)
        .then((response) => {
              if (response != 'success')
                {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('please try after sometime')))
                }
              else
                {
                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      text:
                          "Your order have been placed,soon an agent will contact you",
                      title: "Order placed",
                      barrierDismissible: false,
                      confirmBtnText: "Ok",
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     CupertinoPageRoute(builder: (context) => LandingPage()),
                        //         (Route<dynamic> route) => false);
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => MyHomePage()));
                      })
                }
            });
  }

  Widget _appBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CupertinoNavigationBarBackButton(
              color: MyColors.color1,
            ),
            Text(
              "Demand box",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _onDemandBox() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 0))
            ]),
            child: Form(
              key: _demandFormKey,
              child: TextFormField(
                enabled: true,
                controller: _demandBox,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: 20,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "eg. sugar: 1Kg, rice: 10Kg"),
                validator: (value) {
                  if (_demandBox.text == '' || _demandBox.text == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('please enter few its in demand box')));
                  }
                  return;
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _submitButton(),
          SizedBox(
            height: 50,
          ),
          // _infoPart()
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        if (_demandFormKey.currentState.validate()) {
          onSubmitFunction();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: MyColors.colorDark,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.00),
            child: Text(
              "Submit",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoPart() {
    String bullet = "\u2022";
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '$bullet Enter your requirements',
              style: TextStyle(color: Colors.black.withAlpha(400)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '$bullet Our agent will contact you and your goods will be deli',
              style: TextStyle(color: Colors.black.withAlpha(400)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.color1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [_appBar(), _onDemandBox()],
            ),
          ),
        ),
      ),
    );
  }
}
