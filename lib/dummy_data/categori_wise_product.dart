class CategoryWishProductList{

 List<CategoryWishProductModel> getList(){
   List<CategoryWishProductModel> data = [];

   for(int i=0;i<10;i++){
     data.add(CategoryWishProductModel("Women Clothing & Fashion",i*10));
   }

    return data;
  }

}
class CategoryWishProductModel{
  String category;
  int productQuantity;
  CategoryWishProductModel(this.category,this.productQuantity);
}