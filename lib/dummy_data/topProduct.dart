class TopProductsList{
List<TopProductsModel> getList(){
  List<TopProductsModel> data =[];
  for(int i = 0;i<50;i++){
    data.add(TopProductsModel("iPhone 13Pro Space gray 256 GB ,13Pro Space gray 256 GB ,", "\$${i*1000000000000}.0"));

  }
  return data;
}
}

class TopProductsModel{
  String title,price;

  TopProductsModel(this.title, this.price);
}



