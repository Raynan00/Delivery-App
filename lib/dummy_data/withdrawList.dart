class WithdrawList {
  List<WithdrawModel> getList() {
    List<WithdrawModel> list = [];
    list.add(
        WithdrawModel(date: "15-12-2020", status: "Approved", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-1-2020", status: "Cancle", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "1-1-2020", status: "Pending", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-12-2020", status: "Approved", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-1-2020", status: "Cancle", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "1-1-2020", status: "Pending", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-12-2020", status: "Approved", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-1-2020", status: "Cancle", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "1-1-2020", status: "Pending", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-12-2020", status: "Approved", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-1-2020", status: "Cancle", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "1-1-2020", status: "Pending", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-12-2020", status: "Approved", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-1-2020", status: "Cancle", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "1-1-2020", status: "Pending", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-12-2020", status: "Approved", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "15-1-2020", status: "Cancle", tk: "\$4000000"));
    list.add(
        WithdrawModel(date: "1-1-2020", status: "Pending", tk: "\$4000000"));

    return list;
  }
}

class WithdrawModel {
  String date, status, tk;

  WithdrawModel({ this.date, this.status, this.tk});
}
