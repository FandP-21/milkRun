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

SentryError sentryError = new SentryError();

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
      sentryError.reportError(error, null);
    });
  }

  getTokenValueMethod() async {
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
      sentryError.reportError(error, null);
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
          int index = productsList.length;
          if (lastApiCall == true) {
            productIndex++;
            if (index < totalProduct) {
              getProductListMethod(index);
            } else {
              if (index == totalProduct) {
                if (mounted) {
                  lastApiCall = false;
                  getProductListMethod(index);
                }
              }
            }
          }
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
      sentryError.reportError(error, null);
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
          int index = subCategryByProduct.length;
          if (subProductLastApiCall == true) {
            subCatProductIndex++;
            if (index < subCattotalProduct) {
              getProductToSubCategory(catId, subCatProductIndex);
            } else {
              if (index == subCattotalProduct) {
                if (mounted) {
                  subProductLastApiCall = false;
                  getProductToSubCategory(catId, subCatProductIndex);
                }
              }
            }
          }
          isLoadingSubCatProductsList = false;
        });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubCatProductsList = false;
        });
      }
      sentryError.reportError(error, null);
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
          MyLocalizations.of(context).getLocalizations("PRODUCTS"),
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
                productIndex = productsList.length;
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
          productIndex = productsList.length;
          getTokenValueMethod();
        },
        child: isNewProductsLoading || isLoadingSubCatProductsList
            ? SquareLoader()
            : ListView(children: <Widget>[
                subCategryList.length > 0
                    ? Container(
                        height: 70,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 35,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: subCategryList.length == null
                                ? 0
                                : subCategryList.length,
                            itemBuilder: (BuildContext context, int i) {
                              if (subCategryList[i]['isSelected'] == null) {
                                subCategryList[i]['isSelected'] = false;
                              }
                              return i == 0
                                  ? Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            subCategryByProduct = null;
                                            if (mounted) {
                                              setState(() {
                                                isSelected = true;
                                                isSelectedIndexZero = false;
                                                isSelectetedId = null;
                                                lastApiCall = true;
                                              });
                                            }

                                            productsList = [];
                                            productIndex = productsList.length;

                                            getTokenValueMethod();
                                          },
                                          child: Container(
                                            height: 35,
                                            padding: EdgeInsets.only(
                                                left: 25, right: 25, top: 8),
                                            margin: EdgeInsets.only(right: 15),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? primary
                                                  : Color(0xFFf0F0F0),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations("ALL"),
                                              textAlign: TextAlign.center,
                                              style: textbarlowMediumBlackm(),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                isLoadingSubCatProductsList =
                                                    true;
                                                isSelected = false;
                                                isSelectedIndexZero = true;
                                                isSelectetedId = null;
                                                currentSubCategoryId =
                                                    subCategryList[0]['_id']
                                                        .toString();
                                                subCategryByProduct = [];
                                                subCatProductIndex =
                                                    subCategryByProduct.length;
                                              });
                                            }

                                            getProductToSubCategory(
                                                subCategryList[0]['_id']
                                                    .toString(),
                                                subCatProductIndex);
                                          },
                                          child: Container(
                                            height: 35,
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 8),
                                            margin: EdgeInsets.only(right: 15),
                                            decoration: BoxDecoration(
                                              color: isSelectedIndexZero
                                                  ? primary
                                                  : Color(0xFFf0F0F0),
                                              border: Border.all(
                                                color: Color(0xFFDFDFDF),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            child: Text(
                                              '${subCategryList[0]['title'][0].toUpperCase()}${subCategryList[0]['title'].substring(1)}',
                                              textAlign: TextAlign.center,
                                              style: textbarlowMediumBlackm(),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            isSelected = false;
                                            isSelectedIndexZero = false;
                                            isLoadingSubCatProductsList = true;
                                            currentSubCategoryId =
                                                subCategryList[i]['_id']
                                                    .toString();
                                            isSelectetedId =
                                                subCategryList[i]['_id'];
                                            subCategryByProduct = [];
                                            subCatProductIndex =
                                                subCategryByProduct.length;
                                          });
                                        }

                                        getProductToSubCategory(
                                            subCategryList[i]['_id'].toString(),
                                            subCatProductIndex);
                                      },
                                      child: Container(
                                        height: 35,
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 8),
                                        margin: EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          color: isSelectetedId ==
                                                  subCategryList[i]['_id']
                                              ? primary
                                              : Color(0xFFf0F0F0),
                                          border: Border.all(
                                              color: Color(0xFFDFDFDF)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          '${subCategryList[i]['title'][0].toUpperCase()}${subCategryList[i]['title'].substring(1)}',
                                          textAlign: TextAlign.center,
                                          style: textbarlowMediumBlackm(),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      )
                    : Container(),
                isLoadingSubCatProductsList
                    ? SquareLoader()
                    : subCategryByProduct != null
                        ? Container(
                            height: MediaQuery.of(context).size.height - 201,
                            child: ListView(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    subCategryByProduct.length == 0
                                        ? Center(
                                            child: Image.asset(
                                                'lib/assets/images/no-orders.png'),
                                          )
                                        : GridView.builder(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: subCategryByProduct
                                                        .length ==
                                                    null
                                                ? 0
                                                : subCategryByProduct.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            520,
                                                    crossAxisSpacing: 16,
                                                    mainAxisSpacing: 16),
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              if (subCategryByProduct[i]
                                                      ['averageRating'] ==
                                                  null) {
                                                subCategryByProduct[i]
                                                    ['averageRating'] = 0;
                                              }

                                              return InkWell(
                                                onTap: () {
                                                  var result = Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                        locale: widget.locale,
                                                        localizedValues: widget
                                                            .localizedValues,
                                                        productID:
                                                            subCategryByProduct[
                                                                i]['_id'],
                                                      ),
                                                    ),
                                                  );
                                                  result.then((value) {
                                                    if (value != null) {
                                                      if (mounted) {
                                                        setState(() {
                                                          isLoadingSubCatProductsList =
                                                              true;
                                                          subCategryByProduct =
                                                              [];
                                                          subCatProductIndex =
                                                              subCategryByProduct
                                                                  .length;
                                                        });
                                                      }
                                                      getProductToSubCategory(
                                                          currentSubCategoryId,
                                                          subCatProductIndex);
                                                    }
                                                  });
                                                },
                                                child: Stack(
                                                  children: <Widget>[
                                                    SubCategoryProductCard(
                                                      currency: currency,
                                                      price:
                                                          subCategryByProduct[i]
                                                                  ['variant'][0]
                                                              ['price'],
                                                      productData:
                                                          subCategryByProduct[
                                                              i],
                                                      variantList:
                                                          subCategryByProduct[i]
                                                              ['variant'],
                                                    ),
                                                    subCategryByProduct[i][
                                                                'isDealAvailable'] ==
                                                            true
                                                        ? Positioned(
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 61,
                                                                  height: 18,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFFFFAF72),
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          bottomRight:
                                                                              Radius.circular(10))),
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      subCategryByProduct[i]
                                                                              [
                                                                              'dealPercent']
                                                                          .toString() +
                                                                      "% " +
                                                                      MyLocalizations.of(
                                                                              context)
                                                                          .getLocalizations(
                                                                              "OFF"),
                                                                  style:
                                                                      hintSfboldwhitemed(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: GridView.builder(
                              padding: EdgeInsets.only(bottom: 25),
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: productsList.length == null
                                  ? 0
                                  : productsList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          MediaQuery.of(context).size.width /
                                              520,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16),
                              itemBuilder: (BuildContext context, int i) {
                                if (productsList[i]['averageRating'] == null) {
                                  productsList[i]['averageRating'] = 0;
                                }

                                return InkWell(
                                  onTap: () {
                                    var result = Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                          locale: widget.locale,
                                          localizedValues:
                                              widget.localizedValues,
                                          productID: productsList[i]['_id'],
                                        ),
                                      ),
                                    );
                                    result.then((value) {
                                      if (value != null) {
                                        if (mounted) {
                                          setState(() {
                                            isNewProductsLoading = true;
                                          });
                                        }
                                        productIndex = 0;
                                        productsList = [];
                                        getTokenValueMethod();
                                      }
                                    });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      SubCategoryProductCard(
                                        currency: currency,
                                        price: productsList[i]['variant'][0]
                                            ['price'],
                                        productData: productsList[i],
                                        variantList: productsList[i]['variant'],
                                      ),
                                      productsList[i]['isDealAvailable'] == true
                                          ? Positioned(
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    width: 61,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFAF72),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      " " +
                                                          productsList[i][
                                                                  'dealPercent']
                                                              .toString() +
                                                          "% " +
                                                          MyLocalizations.of(
                                                                  context)
                                                              .getLocalizations(
                                                                  "OFF"),
                                                      style:
                                                          hintSfboldwhitemed(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
              ]),
      ),
      bottomNavigationBar: cartData == null
          ? Container(height: 10.0)
          : InkWell(
              onTap: () {
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currentIndex: 2,
                    ),
                  ),
                );
                result.then((value) {
                  productsList = [];
                  productIndex = productsList.length;
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
                        Container(
                          color: Colors.black,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 7),
                              new Text(
                                '(${cartData['products'].length})  ' +
                                    MyLocalizations.of(context)
                                        .getLocalizations("ITEMS"),
                                style: textBarlowRegularWhite(),
                              ),
                              new Text(
                                "$currency${cartData['subTotal'].toStringAsFixed(2)}",
                                style: textbarlowBoldWhite(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            new Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("GO_TO_CART"),
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
