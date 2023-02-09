class PaymentHistoryList {
  List<PaymentHistoryModel> getList() {
    List<PaymentHistoryModel> list = [];
    list.add(
        PaymentHistoryModel(date: "15-12-2020", status: "Seller paid to admin", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "1-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-12-2020", status: "Seller paid to admin", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "1-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-12-2020", status: "Seller paid to admin", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "1-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-12-2020", status: "Seller paid to admin", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "1-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-12-2020", status: "Seller paid to admin", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "1-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-12-2020", status: "Seller paid to admin", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "15-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));
    list.add(
        PaymentHistoryModel(date: "1-1-2020", status: "Bank payment (TRX ID : 424242424242)", tk: "\$4000000"));

    return list;
  }
}

class PaymentHistoryModel {
  String date, status, tk;

  PaymentHistoryModel({ this.date, this.status, this.tk});
}
