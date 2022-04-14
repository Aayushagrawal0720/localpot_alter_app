import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/ApiServices/localport_invoice_download_service.dart';
import 'package:localport_alter/services/ApiServices/localport_invoice_month_service.dart';
import 'package:localport_alter/services/invoice/invoice_page_service.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  Set<String> _months = {};

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
              "Download Invoice",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  _updateDate(DateTime value, int check) {
    Provider.of<InvoicePageService>(context, listen: false)
        .setDate(value, check);
  }

  Widget _openDatePickerDialog(int check) {
    Dialog _dialog = Dialog(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(2021),
                onDateTimeChanged: (DateTime value) {
                  _updateDate(value, check);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: MyColors.color1,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (context) => _dialog);
  }

  Widget _downloadButton() {
    return GestureDetector(
      onTap: () async {
        Provider.of<LocalportInvoiceDownloadService>(context, listen: false)
            .generateInvoice(
            Provider.of<InvoicePageService>(context, listen: false).getSelected());
        await Future.delayed(Duration(milliseconds: 201));
        showInvoiceDialog(context);
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          color: MyColors.colorDark,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.00),
            child: Text(
              "Download",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthSelector() {
    return Consumer<LocalportInvoiceMonthService>(
        builder: (context, snapshot, child) {
          List<DropdownMenuItem> _items = [];
          if (!snapshot.isLoading() && snapshot
              .getMonths()
              .length > 0) {
            _months = snapshot.getMonths();
            for (var element in _months) {
              _items.add(
                  DropdownMenuItem<String>(
                      value: element, child: Text(element)));
              Provider.of<InvoicePageService>(context, listen: false)
                  .setSelectedItem(element);
            }
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 12,
                        offset: Offset(0, 0))
                  ]),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: snapshot.isLoading()
                      ? Container()
                      :  _months.length>0? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Select month: '),
                            SizedBox(width: 10),
                            Consumer<InvoicePageService>(
                                builder: (context, snapshot, child) {
                                  return DropdownButton(
                                      value: snapshot.getSelected(),
                                      items: _items,
                                      onChanged: (value) {
                                        Provider.of<InvoicePageService>(context,
                                            listen: false)
                                            .setSelectedItem(value);
                                      });
                                })
                          ],
                        ),
                      ),
                      _downloadButton()
                    ],
                  ): Container(
                    child: Text('no record found'),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocalportInvoiceMonthService>(context, listen: false)
        .fetchMonths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _appBar(),
                  _monthSelector(),
                ],
              ),
            ),
          )),
    );
  }
}
