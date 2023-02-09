class RefundList{

 List<RefundModel> getList(){
   List<RefundModel> list=[];
   list.add(RefundModel(id: "20201215-12034564",date: "15-12-2020",status: "Approved",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034555",date: "15-1-2020",status: "Cancle",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034855",date: "1-1-2020",status: "Pending",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034564",date: "15-12-2020",status: "Approved",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034555",date: "15-1-2020",status: "Cancle",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034855",date: "1-1-2020",status: "Pending",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034564",date: "15-12-2020",status: "Approved",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034555",date: "15-1-2020",status: "Cancle",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034855",date: "1-1-2020",status: "Pending",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034564",date: "15-12-2020",status: "Approved",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034555",date: "15-1-2020",status: "Cancle",tk: "\$4000000"));
   list.add(RefundModel(id: "20201215-12034855",date: "1-1-2020",status: "Pending",tk: "\$4000000"));
return list;
   
  }

}

class RefundModel{
  String id,date,status,tk;
  RefundModel({this.id, this.date, this.status,this.tk});
}