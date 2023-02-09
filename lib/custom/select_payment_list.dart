
class PaymentType{
  String key,value;
  PaymentType(this.key, this.value);
}
class PaymentOption{
static List<PaymentType>  getList(){
    List<PaymentType> list = [];
    list.add(PaymentType("select", "Select"));
    list.add(PaymentType("offline", "Offline"));
    list.add(PaymentType("online", "Online"));
    return list;
  }
}