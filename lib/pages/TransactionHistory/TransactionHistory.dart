import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/TransactionsClass.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_transaction_service.dart';
import 'package:localport_alter/widgets/TransactionHistoryCard.dart';
import 'package:provider/provider.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
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
              "Transaction History",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocalportTransactionService>(context, listen: false)
        .fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<LocalportTransactionService>(context, listen: false)
                .fetchTransactions();
            return true;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  _appBar(),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async {
                      Provider.of<LocalportTransactionService>(context,
                              listen: false)
                          .fetchTransactions();
                      return true;
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Consumer<LocalportTransactionService>(
                          builder: (context, snapshot, child) {
                        List<TransactionsClass> _transactions =
                            snapshot.getTransaction();
                        bool isLoading = snapshot.isLoading();
                        bool ifError = snapshot.ifError();
                        String message = snapshot.getMessage();
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: isLoading
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: SpinKitChasingDots(
                                      color: MyColors.color1,
                                      size: 20,
                                    ),
                                  ),
                                )
                              : ifError
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Text(
                                          message==null?"Please try again":message,
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _transactions.length,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return TransactionHistoryCard(
                                            _transactions[index]);
                                      }),
                        );
                      }),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
