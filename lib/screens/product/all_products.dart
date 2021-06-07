import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:groceryPro/model/counterModel.dart';
import 'package:groceryPro/screens/home/home.dart';
import 'package:groceryPro/screens/product/product-details.dart';
import 'package:groceryPro/screens/tab/searchitem.dart';
import 'package:groceryPro/service/common.dart';
import 'package:groceryPro/service/localizations.dart';
import 'package:groceryPro/service/product-service.dart';
import 'package:groceryPro/service/sentry-service.dart';
import 'package:groceryPro/style/style.dart';
import 'package:groceryPro/widgets/loader.dart';
import 'package:groceryPro/widgets/subCategoryProductCart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class AllProducts extends StatefulWidget {
  final Map localizedValues;
  final String locale, currency;
  final bool token;
  final List productsList;

  AllProducts(
      {Key key,
      this.locale,
      this.localizedValues,
      this.productsList,
      this.currency,
      this.token});
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  List productsList = [], subCategryByProduct, subCategryList;
  String currency, currentSubCategoryId;
  bool getTokenValue = false,
      isSelected = true,
      isSelectedIndexZero = false,
      subProductLastApiCall = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController controller;
  ScrollController _scrollController = ScrollController();
  // int index = 0, totalIndex = 1;
  bool productListApiCall = false,
      isNewProductsLoading = false,
      isLoadingSubCatProductsList = false,
      lastApiCall = true;
  var cartData;
  String isSelectetedId;
  int productLimt = 15,
      productIndex = 0,
      totalProduct = 1,
      subCatProductLimt = 15,
      subCatProductIndex = 0,
      subCattotalProduct = 1;

  @override
  void initState() {
    getTokenValueMethod();
    getSubCatList();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getSubCatList() async {
    if (mounted) {
      setState(() {
        isLoadingSubCatProductsList = true;
      });
    }
    await ProductService.getSubCatList().then((onValue) {
      _refreshController.refreshCompleted();

      if (mounted)
        setState(() {
          subCategryList = onValue['response_data'];
          isLoadingSubCatProductsList = false;
        });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubCatProductsList = false;
        });
      }
    });
  }

  getTokenValueMethod() async {
    getProductListMethod(productIndex);
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
          });
        }
      }
      setState(() {
        isNewProductsLoading = true;
      });
      getProductListMethod(productIndex);
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getTokenValue = false;
        });
      }
    });
  }

  getProductListMethod(productIndex) async {
    await ProductService.getProductListAll(productIndex, productLimt)
        .then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          productsList.addAll(onValue['response_data']);
          totalProduct = onValue["total"];
          // int index = productsList.length;
          // if (lastApiCall == true) {
          //   productIndex++;
          //   if (index < totalProduct) {
          //     getProductListMethod(index);
          //   } else {
          //     if (index == totalProduct) {
          //       if (mounted) {
          //         lastApiCall = false;
          //         getProductListMethod(index);
          //       }
          //     }
          //   }
          // }
          isNewProductsLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          productsList = [];
          isNewProductsLoading = false;
        });
      }
    });
  }

  getProductToSubCategory(catId, subCatProductIndex) async {
    if (mounted) {
      setState(() {
        isLoadingSubCatProductsList = true;
      });
    }
    await ProductService.getProductToSubCategoryList(
            catId, subCatProductIndex, subCatProductLimt)
        .then((onValue) {
      if (mounted)
        setState(() {
          subCategryByProduct = onValue['response_data'];
          subCategryByProduct.addAll(onValue['response_data']);
          subCattotalProduct = onValue["total"];
          // int index = subCategryByProduct.length;
          // if (subProductLastApiCall == true) {
          //   subCatProductIndex++;
          //   if (index < subCattotalProduct) {
          //     getProductToSubCategory(catId, subCatProductIndex);
          //   } else {
          //     if (index == subCattotalProduct) {
          //       if (mounted) {
          //         subProductLastApiCall = false;
          //         getProductToSubCategory(catId, subCatProductIndex);
          //       }
          //     }
          //   }
          // }
          isLoadingSubCatProductsList = false;
        });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubCatProductsList = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getTokenValue) {
      CounterModel().getCartDataMethod().then((res) {
        if (mounted) {
          setState(() {
            cartData = res;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          cartData = null;
        });
      }
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: GFAppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          "PRODUCTS",
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              var result = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchItem(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currency: currency,
                      token: getTokenValue),
                ),
              );
              result.then((value) {
                productsList = [];
                // productIndex = productsList.length;
                getTokenValueMethod();
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Icon(
                Icons.search,
              ),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          productsList = [];
          // productIndex = productsList.length;
          getTokenValueMethod();
        },
        child: SquareLoader()

      ),
      bottomNavigationBar: cartData == null
          ? Container(height: 10.0)
          : InkWell(
              onTap: () {
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      // locale: widget.locale,
                      // localizedValues: widget.localizedValues,
                      currentIndex: 2,
                    ),
                  ),
                );
                result.then((value) {
                  productsList = [];
                  // productIndex = productsList.length;
                  getTokenValueMethod();
                });
              },
              child: Container(
                height: 55.0,
                decoration: BoxDecoration(color: primary, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       /* Container(
                          color: Colors.black,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            children: <Widget>[
                              *//*MyLocalizations.of(context)
                                  .getLocalizations("ITEMS")*//*
                              SizedBox(height: 7),
                              new Text(
                                '(${cartData['products'].length})  ' +
                                    "Items",
                                style: textBarlowRegularWhite(),
                              ),
                              new Text(
                                "$currency${cartData['subTotal'].toStringAsFixed(2)}",
                                style: textbarlowBoldWhite(),
                              ),
                            ],
                          ),
                        ),*/
                        Row(
                          children: <Widget>[/*MyLocalizations.of(context)
                              .getLocalizations("GO_TO_CART")*/
                            new Text("Go to cart",
                              style: textBarlowRegularBlack(),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              const IconData(
                                0xe911,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
