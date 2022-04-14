class TransactionsClass {
  String txnid;
  String title;
  String subtitle;
  String amount;
  String date;
  String uid;
  String oid;
  String status;

  TransactionsClass(
      {this.date,
      this.txnid,
      this.uid,
      this.amount,
      this.title,
      this.oid,
      this.subtitle,
      this.status});
}
