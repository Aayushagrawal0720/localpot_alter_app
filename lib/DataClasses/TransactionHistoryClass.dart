class TransactionHistoryClass {
  String txnid;
  String dfrom;
  String cto;
  String gateway_result;
  String datetime;
  String amount;
  String uid;
  String status;

  TransactionHistoryClass(
      {this.status,
      this.dfrom,
      this.amount,
      this.uid,
      this.cto,
      this.datetime,
      this.gateway_result,
      this.txnid});
}
