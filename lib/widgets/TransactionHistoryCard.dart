import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/TransactionsClass.dart';
import 'package:localport_alter/pages/TransactionHistory/TransactionDetailPage.dart';
import 'package:localport_alter/resources/FadePageRoute.dart';

class TransactionHistoryCard extends StatefulWidget {
  TransactionsClass transactions;

  TransactionHistoryCard(this.transactions);

  @override
  _TransactionHistoryCardState createState() => _TransactionHistoryCardState();
}

class _TransactionHistoryCardState extends State<TransactionHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              fadePageRoute(
                  context, TransactionDetailsPage(widget.transactions)));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 0),
                blurRadius: 12)
          ]),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.transactions.title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Container()),
                    Text(widget.transactions.amount,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.transactions.amount.contains("+")
                                ? Colors.green
                                : Colors.red))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      widget.transactions.subtitle,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(child: Container()),
                    Text(
                      widget.transactions.date,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
