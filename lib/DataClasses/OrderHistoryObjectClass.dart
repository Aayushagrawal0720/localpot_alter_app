import 'package:localport_alter/DataClasses/delivery_charge_class.dart';

class OrderHistoryObjectClass {
  String weight;
  String oid;
  String id;
  String status;
  DateTime date;
  String uid;
  String fname;
  String lname;
  String phone;
  String vendorName;
  String dprice;
  String distance;
  String pickutext;
  String dropText;
  String delInstruction;
  String rName;
  String rPhone;
  bool roundTrip;
  List<DeliveryChargeClass> priceDistribution;

  OrderHistoryObjectClass(
      {this.weight,
      this.phone,
      this.id,
      this.uid,
      this.status,
      this.lname,
      this.fname,
      this.date,
      this.oid,
      this.dprice,
      this.distance,
      this.delInstruction,
      this.dropText,
      this.pickutext,
      this.vendorName,
      this.rName,
      this.rPhone,
      this.roundTrip,
      this.priceDistribution});
}
