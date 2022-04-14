import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/TransactionsClass.dart';
import 'package:localport_alter/resources/MyColors.dart';

class TransactionDetailsPage extends StatefulWidget {
  TransactionsClass transactions;

  TransactionDetailsPage(this.transactions);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  _status() {
    String status = widget.transactions.status;
    Color _color;
    IconData _childIcon;
    switch (status) {
      case 'Success':
        {
          _childIcon = Icons.done;
          _color = Colors.green;
          break;
        }
      case 'Pending':
        {
          _childIcon = Icons.pending;
          _color = Colors.amber;
          break;
        }
      case 'Failure':
        {
          _childIcon = Icons.cancel;
          _color = Colors.green;
          break;
        }
      default:
        {
          _childIcon = Icons.done;
          _color = Colors.green;
          break;
        }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.width / 5,
          width: MediaQuery.of(context).size.width / 5,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              _childIcon,
              color: Colors.white,
              size: MediaQuery.of(context).size.width / 8,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          status.toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  _detailFields() {
    List<Map<String, String>> _list = [];
    String type = widget.transactions.amount.contains("+") ? "Credit" : "Debit";
    String amount;
    if (widget.transactions.amount.contains("+")) {
      amount = widget.transactions.amount.split("+")[1];
    } else {
      amount = widget.transactions.amount.split("-")[1];
    }

    String description =
        '${type == "Credit" ? "Amount credited to wallet" : widget.transactions.oid}';

    _list.add({"Type": type});
    _list.add({"Date & Time": widget.transactions.date});
    _list.add({"From": type == 'Credit' ? 'Bank' : 'Wallet'});
    _list.add({"To": type == 'Credit' ? 'Wallet' : 'For order'});
    _list.add({"Amount": amount});
    _list.add({"Description": description});

    return ListView.builder(
        itemCount: _list.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      _list[index].keys.first,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Container()),
                    Text(
                      _list[index].values.first,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              )
            ],
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
              "Transaction detail",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_appBar(), _status(), _detailFields()],
            ),
          ),
        ),
      ),
    );
  }
}
