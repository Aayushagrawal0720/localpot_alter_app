import 'package:flutter/cupertino.dart';
import 'package:localport_alter/DataClasses/OrderHistoryObjectClass.dart';

class LocalportOrderDetailsServce with ChangeNotifier {
  OrderHistoryObjectClass _orderDetail;

  setOrder(OrderHistoryObjectClass order) {
    this._orderDetail = order;
  }

  OrderHistoryObjectClass getOrder() => _orderDetail;
}
