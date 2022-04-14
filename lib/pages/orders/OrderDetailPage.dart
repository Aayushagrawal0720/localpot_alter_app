import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/resources/Strings.dart';
import 'package:localport_alter/services/ApiServices/localport_order_detail_service.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderHistoryObjectClass _historyObjectClass = OrderHistoryObjectClass();

  listCard(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$key :",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 3,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
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
              "Order Detail",
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<LocalportOrderDetailsServce>(
                builder: (context, snapshot, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appBar(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 12,
                              color: Colors.grey.withOpacity(0.3),
                              offset: Offset(
                                0,
                                0,
                              ))
                        ]),
                    child: Column(
                      children: [
                        listCard(parcelWeight, snapshot.getOrder().weight),
                        listCard(pickupLocation, snapshot.getOrder().pickutext),
                        listCard(dropLocation, snapshot.getOrder().dropText),
                        listCard(receiverName, snapshot.getOrder().rName),
                        listCard(receiverPhone, snapshot.getOrder().rPhone),
                        listCard(roundTrip, snapshot.getOrder().roundTrip.toString()),
                        listCard(
                            delInstruction,
                            snapshot.getOrder().delInstruction == null
                                ? " del ins"
                                : snapshot.getOrder().delInstruction),
                        Divider(
                          thickness: 1,
                        ),
                        listCard("Status", snapshot.getOrder().status),
                        listCard(distance, snapshot.getOrder().distance),
                        snapshot.getOrder().priceDistribution.length>0?ListView.builder(
                            itemCount: snapshot.getOrder().priceDistribution.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              List<DeliveryChargeClass> _list = snapshot.getOrder().priceDistribution;
                              return listCard(
                                  _list[index].key.toString(), _list[index].value.toString());
                            }):Container(),
                        Divider(
                          thickness: 1,
                        ),
                        listCard('Total', snapshot.getOrder().dprice.toString()),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
