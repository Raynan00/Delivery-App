import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/common_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/loading.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/product_review_response.dart';
import 'package:active_ecommerce_seller_app/data_model/products_response.dart';
import 'package:active_ecommerce_seller_app/dummy_data/allProducts.dart';
import 'package:active_ecommerce_seller_app/dummy_data/topProduct.dart';
import 'package:active_ecommerce_seller_app/helpers/reg_ex_inpur_formatter.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/product_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:active_ecommerce_seller_app/screens/product_reviews.dart';
import 'package:active_ecommerce_seller_app/screens/packages.dart';
import 'package:active_ecommerce_seller_app/ui_elements/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

class Products extends StatefulWidget {
  final bool fromBottomBar;

  const Products({Key key, this.fromBottomBar = false}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _isProductInit = false;
  bool _showMoreProductLoadingContainer = false;

  List<Product> _productList = [];

  // List<bool> _productStatus=[];
  // List<bool> _productFeatured=[];

  String _remainingProduct = "...";
  String _currentPackageName = "...";
  BuildContext loadingContext;
  BuildContext switchContext;
  BuildContext featuredSwitchContext;

  //MenuOptions _menuOptionSelected = MenuOptions.Published;

  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 0);

  // double variables
  double mHeight = 0.0, mWidht = 0.0;
  int _page = 1;

  getProductList() async {
    var productResponse = await ProductRepository().getProducts(page: _page);
    if (productResponse.data.isEmpty) {
      ToastComponent.showDialog(
          LangText(context: context).getLocal().common_no_more_product,
          gravity: Toast.center,
          backgroundColor: MyTheme.white,
          textStyle:TextStyle(color:Colors.black) );
    }
    _productList.addAll(productResponse.data);
    _showMoreProductLoadingContainer = false;
    _isProductInit = true;
    setState(() {});
  }

  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    _currentPackageName=response.shopInfo.sellerPackage;
    setState(() {});
    return true;
  }

  getProductRemainingUpload() async {
    var productResponse = await ProductRepository().remainingUploadProducts();
    _remainingProduct = productResponse.ramainingProduct.toString();

    setState(() {});
  }

  duplicateProduct(int id) async {
    loading();
    var response = await ProductRepository().productDuplicateReq(id: id);
    Navigator.pop(loadingContext);
    if (response.result) {
      resetAll();
    }
    ToastComponent.showDialog(response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: TextStyle(color: MyTheme.black),
    );
  }

  deleteProduct(int id) async {
    loading();
    var response = await ProductRepository().productDeleteReq(id: id);
    Navigator.pop(loadingContext);
    if (response.result) {
      resetAll();
    }
    ToastComponent.showDialog(response.message,
        gravity: Toast.center,
        duration: 3,
        textStyle: TextStyle(color: MyTheme.black),
        );
  }

  productStatusChange(int index, bool value, setState, id) async {
    loading();
    var response = await ProductRepository()
        .productStatusChangeReq(id: id, status: value ? 1 : 0);
    Navigator.pop(loadingContext);
    if (response.result) {
        // _productStatus[index] = value;
        _productList[index].status = value;
        resetAll();
    }
    Navigator.pop(switchContext);
    ToastComponent.showDialog(response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: TextStyle(color: MyTheme.black),
    );
  }

  productFeaturedChange({int index, bool value, setState, id}) async {
    print(value);
    loading();
    var response = await ProductRepository()
        .productFeaturedChangeReq(id: id, featured: value ? 1 : 0);
    Navigator.pop(loadingContext);

    if (response.result) {


      // _productFeatured[index]=value;
        _productList[index].featured = value;
        resetAll();
    }
    Navigator.pop(featuredSwitchContext);

    ToastComponent.showDialog(response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: TextStyle(color: MyTheme.black),
    );
  }

  scrollControllerPosition() {
    _scrollController.addListener(() {
      print("po");
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _showMoreProductLoadingContainer = true;
        setState(() {
          _page++;
        });
        getProductList();
      }
    });
  }

  cleanAll() {
    print("clean all");
    _isProductInit = false;
    _showMoreProductLoadingContainer = false;
    _productList = [];
    _page = 1;
    // _productStatus=[];
    // _productFeatured=[];
    _remainingProduct = "....";
    _currentPackageName="...";
    setState(() {});
  }

  fetchAll() {
    getProductList();
    _getAccountInfo();
    getProductRemainingUpload();
    setState(() {});

  }

  resetAll() {
    cleanAll();
    fetchAll();
  }

  _tabOption(int index, productId, listIndex) {
    switch (index) {
      case 0:
        showPublishUnPublishDialog(listIndex, productId);
        break;
      case 1:
        showFeaturedUnFeaturedDialog(listIndex, productId);
        break;
      case 2:
        showDeleteWarningDialog(productId);
        //deleteProduct(productId);
        break;
      case 3:
        print(productId);
        duplicateProduct(productId);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    scrollControllerPosition();
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        child: Column(
          children: [
            Visibility(
                visible: !widget.fromBottomBar,
                child: MyAppBar(
                        context: context,
                        title:
                            LangText(context: context).getLocal().drawer_orders)
                    .show()),
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                resetAll();
                // Future.delayed(Duration(seconds: 1));
              },
              child: Container(
                height: DeviceInfo(context).getHeight()  - (AppBar().preferredSize.height+50) ,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      buildTop2BoxContainer(context),
                      Visibility(
                        visible: seller_package_addon.$,
                          child: buildPackageUpgradeContainer(context)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: _isProductInit
                            ? productsContainer()
                            : ShimmerHelper().buildListShimmer(
                                item_count: 20, item_height: 80.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPackageUpgradeContainer(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppStyles.itemMargin,
        ),
        MyWidget().myContainer(
            marginY: 15,
            height: 40,
            width: DeviceInfo(context).getWidth(),
            borderRadius: 6,
            borderColor: MyTheme.app_accent_color,
            bgColor: MyTheme.app_accent_color_extra_light,
            child: InkWell(
              onTap: () {
                MyTransaction(context: context).push(Packages());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icon/package.png", height: 20, width: 20),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        LangText(context: context)
                            .getLocal()
                            .dashboard_current_package,
                        style: TextStyle(fontSize: 10, color: MyTheme.grey_153),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _currentPackageName,
                        style: TextStyle(
                            fontSize: 10,
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        LangText(context: context)
                            .getLocal()
                            .dashboard_upgrade_package,
                        style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Image.asset("assets/icon/next_arrow.png",
                          color: MyTheme.app_accent_color,
                          height: 8.7, width: 7),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Container buildTop2BoxContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: MyTheme.app_accent_border),
                color: MyTheme.app_accent_color,
              ),
              height: 75,
              width: mWidht / 2 - 23,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      LangText(context: context)
                          .getLocal()
                          .product_screen_remaining_uploads,
                      style: MyTextStyle().dashboardBoxText(context),
                    ),
                    Text(
                      _remainingProduct,
                      style: MyTextStyle().dashboardBoxNumber(context),
                    ),
                  ],
                ),
              )),
          SizedBox(width: AppStyles.itemMargin,),
          Container(
              child: SubmitBtn.show(
            onTap: () {
              MyTransaction(context: context).push(const ProductReviews());
            },
            borderColor: MyTheme.app_accent_color,
            backgroundColor: MyTheme.app_accent_color_extra_light,
            height: 75,
            width: mWidht / 2 - 23,
            radius: 10,
            child: Container(
              padding: EdgeInsets.all(10),
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    LangText(context: context)
                        .getLocal()
                        .product_screen_reviews,
                    style: MyTextStyle()
                        .dashboardBoxText(context)
                        .copyWith(color: MyTheme.app_accent_color),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/reviews.png',
                        color: MyTheme.app_accent_color,
                        height: 24,
                        width: 42,
                        fit: BoxFit.contain,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget productsContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangText(context: context).getLocal().product_screen_all_products,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MyTheme.app_accent_color),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _productList.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print(index);
                if (index == _productList.length) {
                  return moreProductLoading();
                }
                return productItem(
                    index: index,
                    productId: _productList[index].id,
                    imageUrl: _productList[index].thumbnailImg,
                    productTitle: _productList[index].name,
                    category: _productList[index].category,
                    productPrice: _productList[index].price.toString(),
                    quantity: _productList[index].quantity.toString());
              }),
        ],
      ),
    );
  }

  Container productItem(
      {int index,
      productId,
      String imageUrl,
      String productTitle,
      category,
      String productPrice,
      String quantity}) {
    return MyWidget.customCardView(
      elevation: 5,
        backgroundColor: MyTheme.white,
        height: 90,
        width: mWidht,
        margin: EdgeInsets.only(bottom: 20,),
        borderColor: MyTheme.light_grey,
        borderRadius: 6,
        child: Row(
          children: [
            MyWidget.imageWithPlaceholder(
                width: 84.0,
                height: 90.0,
                fit: BoxFit.cover,
                url: imageUrl,
                radius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),),),
            // Image.asset(ImageUrl,width: 80,height: 80,fit: BoxFit.contain,),
            SizedBox(
              width: 11,
            ),
            Container(
              width: mWidht - 129,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: mWidht - 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productTitle,
                                style:
                                    TextStyle(fontSize: 12, color: MyTheme.font_grey,fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child:
                              showOptions(listIndex: index, productId: productId),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(productPrice,
                              style: TextStyle(
                                  fontSize: 13, color: MyTheme.app_accent_color,fontWeight: FontWeight.w500)),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icon/product.png",
                              width: 10,
                              height: 10,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Text(quantity,
                                  style: TextStyle(
                                      fontSize: 13, color: MyTheme.grey_153)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }


  showDeleteWarningDialog(id){
    showDialog(context: context, builder: (context)=>Container(
      width: DeviceInfo(context).getWidth()*1.5,
      child: AlertDialog(
        title: Text(LangText(context: context).getLocal().common_warning,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: MyTheme.red),),
        content: Text(LangText(context: context).getLocal().common_delete_warning_text,style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        actions: [
          FlatButton(
              color: MyTheme.app_accent_color,
              onPressed: (){
                Navigator.pop(context);
              }, child: Text(LangText(context: context).getLocal().common_no,style: TextStyle(color: MyTheme.white,fontSize: 12),)),
          FlatButton(
              color: MyTheme.app_accent_color,
              onPressed: (){
                Navigator.pop(context);
                deleteProduct(id);
              }, child: Text(LangText(context: context).getLocal().common_yes,style: TextStyle(color: MyTheme.white,fontSize: 12))),
        ],
      ),
    ));
  }

  Widget showOptions({listIndex, productId}) {
    return Container(
      width: 35,
      child: PopupMenuButton<MenuOptions>(

        offset: Offset(-12, 0),
        child: Padding(
          padding:  EdgeInsets.zero,
          child: Container(
            width: 35,
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/icon/more.png",
                width: 3, height: 15, fit: BoxFit.contain, color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {
          _tabOption(result.index, productId, listIndex);
          // setState(() {
          //   //_menuOptionSelected = result;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          const PopupMenuItem<MenuOptions>(
            value: MenuOptions.Published,
            child: Text('Published'),
          ),
          const PopupMenuItem<MenuOptions>(
            value: MenuOptions.Featured,
            child: Text('Featured'),
          ),
          const PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text('Delete'),
          ),
          const PopupMenuItem<MenuOptions>(
            value: MenuOptions.Duplicate,
            child: Text('Duplicate'),
          ),
        ],
      ),
    );
  }

  void showPublishUnPublishDialog(int index, id) {
    //print(index.toString()+" "+_productStatus[index].toString());
    showDialog(
        context: context,
        builder: (context) {
          switchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 75,
              width: DeviceInfo(context).getWidth(),
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index].status ? "Published" : "Unpublished",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].status,
                      activeColor: MyTheme.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        productStatusChange(index, value, setState, id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void showFeaturedUnFeaturedDialog(int index, id) {
    //print(_productFeatured[index]);
    print(index);
    showDialog(
        context: context,
        builder: (context) {
          featuredSwitchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 75,
              width: DeviceInfo(context).getWidth(),
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index].featured ? "Featured" : "Unfeatured",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].featured,
                      activeColor: MyTheme.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        productFeaturedChange(
                            index: index,
                            value: value,
                            setState: setState,
                            id: id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context).common_loading}"),
            ],
          ));
        });
  }

  Widget moreProductLoading() {
    return _showMoreProductLoadingContainer
        ? Container(
            alignment: Alignment.center,
            child: SizedBox(
              height: 40,
              width: 40,
              child: Row(
                children: [
                  SizedBox(
                    width: 2,
                    height: 2,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          )
        : SizedBox(
            height: 5,
            width: 5,
          );
  }
}

enum MenuOptions { Published, Featured, Delete, Duplicate }
