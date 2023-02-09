class CommissionHistoryList{
  String id,date,whoPaid, amount;
  CommissionHistoryList({this.id, this.whoPaid, this.amount,this.date});
  
  
  
List<CommissionHistoryList>  getList(){
    List<CommissionHistoryList> list = [];
    list.add(CommissionHistoryList(id: "20210308-12462162",whoPaid: "Admin paid to seller",amount: "\$8885555555555.00",date: "21-03-2022"));
    list.add(CommissionHistoryList(id: "20210308-12462161",whoPaid: "Admin paid to seller",amount: "\$888555555555555.00",date: "21-03-2022"));
       list.add(CommissionHistoryList(id: "20210308-12462122",whoPaid: "Admin paid to seller",amount: "\$8885555555555.00",date: "21-03-2022"));
    list.add(CommissionHistoryList(id: "20210308-12462162",whoPaid: "Admin paid to seller",amount: "\$888555555555.00",date: "21-03-2022"));
       list.add(CommissionHistoryList(id: "20210308-12462000",whoPaid: "Admin paid to seller",amount: "\$888555555555.00",date: "21-03-2022"));
    list.add(CommissionHistoryList(id: "20210308-12462162",whoPaid: "Admin paid to seller",amount: "\$85555555.00",date: "21-03-2022"));

    return list;

}
  
}