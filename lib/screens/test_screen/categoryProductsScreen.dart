import 'package:flutter/material.dart';
import 'package:groceryPro/model/AllProductResponseModel.dart';
import 'package:groceryPro/networking/Response.dart';
import 'package:groceryPro/service/product-service.dart';
import 'package:groceryPro/widgets/customAppbar.dart';
import 'package:groceryPro/widgets/loader.dart';
import 'package:groceryPro/widgets/productCard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:groceryPro/networking/bloc/ProductsBloc.dart';
import 'package:groceryPro/utils/constants.dart' as Constantss;

class CategoryProductScreen extends StatefulWidget {
  final bool getTokenValue;
  final String collectionId;
  CategoryProductScreen({Key key, this.getTokenValue, this.collectionId});

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  bool isLoadingProductsList = false, isLoadingcategoryList = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ProductsBloc _productsBloc;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();

    _productsBloc = ProductsBloc();
    _productsBloc.getProductForCollection(widget.collectionId);
    _productsBloc.collectionProductsStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Constantss.onLoading(context);
            break;
          case Status.COMPLETED:
            print(event.message);
            Constantss.stopLoader(context);

            _products = event.data.products;
            break;
          case Status.ERROR:
            print(event.message);
            Constantss.stopLoader(context);
            if (event.message == "Invalid Request: null") {
              Constantss.showMyDialog("Invalid Credentials.", context);
            } else {
              Constantss.showMyDialog(event.message, context);
            }
            break;
        }
      });
    });

    // getCategoryList();
  }

  // getCategoryList() async {
  //   if (mounted) {
  //     setState(() {
  //       isLoadingcategoryList = true;
  //     });
  //   }
  //   await ProductService.getCategoryList().then((onValue) {
  //     _refreshController.refreshCompleted();
  //     if (mounted) {
  //       setState(() {
  //         // categoryList = onValue['response_data'];
  //         isLoadingcategoryList = false;
  //       });
  //     }
  //   }).catchError((error) {
  //     if (mounted) {
  //       setState(() {
  //         // categoryList = [];
  //         isLoadingcategoryList = false;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.backArrow,
        titleText: "Fruits and Veg",
        context: context,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          // getCategoryList();
        },
        child: isLoadingcategoryList
            ? SquareLoader()
            : Container(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _products==null || _products.length == 0 ? 0 : _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(
                      imageUrl:
                      _products[index].images[0].src,
                      onTap: () {
                        //TODO: Add to Cart
                        print("Add to Cart");
                      },
                      productName: _products[index].title,
                      price: "\$${_products[index].variants[0].price}",
                      scale: 'each',
                    );
                  },
                ),
              ),
      ),
    );
  }
}
