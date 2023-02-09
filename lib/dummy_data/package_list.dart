class PackageList{
  
List<PackageModel>  getList(){
  List<PackageModel> list =[];
  
  list.add(PackageModel(packageName: "Basic",packagePrice:"\$50.00" ,packageDate:"30 Days" ,packageProduct:"100 Product Upload Limit" ,packageDigitalProduct:"40 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Standard",packagePrice:"\$80.00" ,packageDate:"60 Days" ,packageProduct:"150 Product Upload Limit" ,packageDigitalProduct:"60 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Basic",packagePrice:"\$50.00" ,packageDate:"30 Days" ,packageProduct:"100 Product Upload Limit" ,packageDigitalProduct:"40 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Standard",packagePrice:"\$80.00" ,packageDate:"60 Days" ,packageProduct:"150 Product Upload Limit" ,packageDigitalProduct:"60 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Basic",packagePrice:"\$50.00" ,packageDate:"30 Days" ,packageProduct:"100 Product Upload Limit" ,packageDigitalProduct:"40 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Standard",packagePrice:"\$80.00" ,packageDate:"60 Days" ,packageProduct:"150 Product Upload Limit" ,packageDigitalProduct:"60 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Basic",packagePrice:"\$50.00" ,packageDate:"30 Days" ,packageProduct:"100 Product Upload Limit" ,packageDigitalProduct:"40 Digital Product Upload Limit" ));
  list.add(PackageModel(packageName: "Standard",packagePrice:"\$80.00" ,packageDate:"60 Days" ,packageProduct:"150 Product Upload Limit" ,packageDigitalProduct:"60 Digital Product Upload Limit" ));
return list;

  }
}

class PackageModel{
  String packageName, packagePrice, packageDate, packageProduct, packageDigitalProduct;

  PackageModel(
      {this.packageName,
      this.packagePrice,
      this.packageDate,
      this.packageProduct,
      this.packageDigitalProduct});
}