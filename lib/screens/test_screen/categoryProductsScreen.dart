import 'package:flutter/material.dart';
import 'package:groceryPro/service/product-service.dart';
import 'package:groceryPro/widgets/customAppbar.dart';
import 'package:groceryPro/widgets/loader.dart';
import 'package:groceryPro/widgets/productCard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryProductScreen extends StatefulWidget {
  final bool getTokenValue;
  CategoryProductScreen({Key key, this.getTokenValue});

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  bool isLoadingProductsList = false, isLoadingcategoryList = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  getCategoryList() async {
    if (mounted) {
      setState(() {
        isLoadingcategoryList = true;
      });
    }
    await ProductService.getCategoryList().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          // categoryList = onValue['response_data'];
          isLoadingcategoryList = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          // categoryList = [];
          isLoadingcategoryList = false;
        });
      }
    });
  }

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
          getCategoryList();
        },
        child: isLoadingcategoryList
            ? SquareLoader()
            : Container(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 20,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(
                      imageUrl:
                          "https://live-production.wcms.abc-cdn.net.au/b983edcea41673904b177071b138dadb?impolicy=wcms_crop_resize&cropH=861&cropW=1529&xPos=0&yPos=345&width=862&height=485",
                      onTap: () {
                        //TODO: Add to Cart
                        print("Add to Cart");
                      },
                      productName: 'The odd bunch cool Apple',
                      price: "\$1234",
                      scale: 'each',
                    );
                  },
                ),
              ),
      ),
    );
  }
}
