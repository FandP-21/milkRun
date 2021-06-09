import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:groceryPro/model/AllProductResponseModel.dart';
import 'package:groceryPro/model/CollectionsResponseModel.dart';
import 'package:groceryPro/networking/Response.dart';
import 'package:groceryPro/networking/bloc/ProductsBloc.dart';
import 'package:groceryPro/screens/categories/allcategories.dart';
import 'package:groceryPro/screens/categories/subcategories.dart';
import 'package:groceryPro/screens/product/all_deals.dart';
import 'package:groceryPro/screens/product/all_products.dart';
import 'package:groceryPro/screens/product/product-details.dart';
import 'package:groceryPro/service/cart-service.dart';
import 'package:groceryPro/service/common.dart';
import 'package:groceryPro/service/constants.dart';
import 'package:groceryPro/service/localizations.dart';
import 'package:groceryPro/service/product-service.dart';
import 'package:groceryPro/service/sentry-service.dart';
import 'package:groceryPro/style/style.dart';
import 'package:groceryPro/widgets/loader.dart';
import 'package:groceryPro/screens/test_screen/categoryProductsScreen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:groceryPro/utils/constants.dart' as Constantss;

class Store extends StatefulWidget {
  final Map localizedValues;
  final String locale, currentLocation;

  Store(
      {Key key, this.currentLocation, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeydrawer =
      new GlobalKey<ScaffoldState>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool getTokenValue = true,
      isLocationLoading = false,
      isBannerLoading = false,
      isLoadingAllData = false,
      selectedCategories = false;
  // List categoryList,
  //     searchProductList,
  //     dealList,
  //     topDealList,
  //     bannerList;
  String currency;
  int catIndex;
  final List<String> assetImg = [
    'lib/assets/images/product.png',
  ];

  TabController tabController;

  var addressData;
  String locale;

  ProductsBloc _productsBloc;
  List<Product> _products = [];
  List<CollectionListing> _collectionListings = [];

  @override
  void initState() {

    _productsBloc = ProductsBloc();
    _productsBloc.getProducts();
    _productsBloc.productsStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Constantss.onLoading(context);
            break;
          case Status.COMPLETED:
            print(event.message);
            Constantss.stopLoader(context);
            // navigateToTab(context);
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

    //get collection
    _productsBloc.getCollection();
    _productsBloc.collectionStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Constantss.onLoading(context);
            break;
          case Status.COMPLETED:
            print(event.message);
            Constantss.stopLoader(context);
            _refreshController.refreshCompleted();
            _collectionListings = event.data.collectionListings;
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
    // getToken();
    // getBanner();
    // getAllData();

    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getToken() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getSelectedLanguage().then((value) async {
      locale = value;
      await Common.getToken().then((onValue) {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              getTokenValue = true;
              getCartData();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              getTokenValue = false;
            });
          }
        }
      }).catchError((error) {});
    });
  }

  getCartData() {
    CartService.getProductToCart().then((value) {
      if (value['response_data'] is Map &&
          value['response_data']['products'] != []) {
        Common.setCartData(value['response_data']);
      } else if (value['response_code'] == 403) {
        Common.setCartData(null);
      } else {
        Common.setCartData(null);
      }
    }).catchError((error) {});
  }

  getBanner() async {
    if (mounted) {
      setState(() {
        isBannerLoading = true;
      });
    }
    await Common.getBanner().then((value) {
      if (value == null || value['response_data'] == null) {
        if (mounted) {
          setState(() {
            getBannerData();
          });
        }
      } else {
        if (mounted) {
          // setState(() {
          //   if (value['response_data'] == []) {
          //     bannerList = [];
          //   } else {
          //     bannerList = value['response_data'];
          //   }
          //   getBannerData();
          //   isBannerLoading = false;
          // });
        }
      }
    });
  }

  getBannerData() async {
    await ProductService.getBanner().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        // setState(() {
        //   if (onValue['response_data'] == []) {
        //     bannerList = [];
        //   } else {
        //     bannerList = onValue['response_data'];
        //   }
        //   isBannerLoading = false;
        // });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isBannerLoading = false;
        });
      }
    });
  }

  getAllData() async {
    if (mounted) {
      setState(() {
        isLoadingAllData = true;
      });
    }
    await Common.getAllData().then((value) {
      if (value == null || value['response_data'] == null) {
        if (mounted) {
          setState(() {
            getAllDataMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoadingAllData = false;
            // productsList = value['response_data']['products'];
            // categoryList = value['response_data']['categories'];
            // dealList = value['response_data']['dealsOfDay'];
            // topDealList = value['response_data']['topDeals'];

            getAllDataMethod();
          });
        }
      }
    });
  }

  getAllDataMethod() async {
    await ProductService.getProdCatDealTopDeal().then((onValue) {
      _refreshController.refreshCompleted();

      if (mounted) {
        setState(() {
          // productsList = onValue['response_data']['products'];
          // categoryList = onValue['response_data']['categories'];
          // dealList = onValue['response_data']['dealsOfDay'];
          // topDealList = onValue['response_data']['topDeals'];
          isLoadingAllData = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingAllData = false;
        });
      }
    });
  }

  categoryRow() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                "Explore by categories",
                style: textBarlowMediumBlack(),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  selectedCategories = false;
                  catIndex = null;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategories(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      getTokenValue: getTokenValue,
                    ),
                  ),
                );
              },
              child: Text(
                "VIEW_ALL",
                style: textBarlowMediumPrimary(),
              ),
            )
          ],
        ),
        SizedBox(height: 20),

        // category
        SizedBox(
          height: 100,
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _collectionListings.length != null ? _collectionListings.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCategories = true;
                      catIndex = index;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductScreen(
                          collectionId: _collectionListings[index].collectionId.toString(),
                            /*locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            catId: _collectionListings[index].collectionId.toString(),
                            isSubCategoryAvailable:*//* _collectionListings[index].
                                    ['isSubCategoryAvailable'] ??*//*
                                false,*/
                            /*catTitle:
                                '${_collectionListings[index].title[0].toUpperCase()}${_collectionListings[index].title.substring(1)}',
                            token: getTokenValue*/),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedCategories && catIndex == index
                            ? primary
                            : Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(30)),
                    width: 70,
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                            _collectionListings[index].image == null
                                ? _collectionListings[index].image.src
                                : _collectionListings[index].image.src,
                            height: 40,
                            width: 40),
                        SizedBox(height: 5),
                        Text(
                          '${_collectionListings[index].title[0].toUpperCase()}${_collectionListings[index].title.substring(1)}',
                          style: selectedCategories && catIndex == index
                              ? textmontserratsmediumw()
                              : textmontserratsmedium(),
                        )
                      ],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }

  banner() {
    return GFCarousel(
      autoPlay: true,
      viewportFraction: 1.0,
      aspectRatio: 2.4,
      items: _collectionListings.map((url) {
        return InkWell(
          onTap: () {
            // if (url['bannerType'] == "PRODUCT") {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ProductDetails(
            //         locale: widget.locale,
            //         localizedValues: widget.localizedValues,
            //         productID: url['productId'],
            //       ),
            //     ),
            //   );
            // } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategories(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      catId: url.collectionId.toString()/*['categoryId']*/,
                      catTitle:
                          '${url.title[0].toUpperCase()}${url.title.substring(1)}',
                      token: getTokenValue),
                ),
              );
            // }
          },
          child: Container(
              margin: EdgeInsets.all(10),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: primary.withOpacity(0.30)),
              child: Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${url.title[0].toUpperCase()}${url.title.substring(1).split(',').join('\n')}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: textfuturabold(),
                          ),
                          Row(children: [
                            Text("ORDER_NOW"),
                            Icon(Icons.arrow_right)
                          ])
                        ],
                      )),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: url.image == null
                          ? Container()
                          : Image.network(
                              url.image == null
                                  ? url.image.src
                                  :"",
                              width: 106,
                              height: 94,
                            )),
                ],
              )),
        );
      }).toList(),
    );
  }

  productRow(titleTranslate,List<Product> list) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              titleTranslate,
              style: textBarlowMediumBlack(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AllProducts(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      productsList: list,
                      currency: currency,
                      token: getTokenValue,
                    ),
                  ),
                );
              },
              child: Text(
                "VIEW_ALL",
                style: textBarlowMediumPrimary(),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length != null ? list.length : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: MediaQuery.of(context).size.width / 435,
          ),
          itemBuilder: (BuildContext context, int i) {
            /*if (list[i].['averageRating'] == null) {
              list[i]['averageRating'] = 0;
            }*/

            return Padding(
                padding: const EdgeInsets.all(1.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            productID: list[i].id.toString(),
                          ),
                        ),
                      );
                    },
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              list[i].image.src != null
                                  ? /*Constants.imageUrlPath +
                                      "/tr:dpr-auto,tr:w-500" +
                                     */ list[i].image.src
                                  : list[i].image.src,
                              fit: BoxFit.cover,
                              height: 123,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${list[i].title[0].toUpperCase()}${list[i].title.substring(1)}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textmontserratregularsml(),
                                    ),
                                  ],
                                )),
                                /*list[i]['averageRating'] == null ||
                                        list[i]['averageRating'] == 0 ||
                                        list[i]['averageRating'] == '0'
                                    ? Container()
                                    : Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                            Text(
                                              list[i]['averageRating']
                                                  .toStringAsFixed(1),
                                              style:
                                                  textmontserratregularsmldull(),
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 10,
                                              color: Colors.black
                                                  .withOpacity(0.40),
                                            )
                                          ]))*/
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    list[i].status == "active"
                                        ? '$currency${(list[i].variants[0].price)}'
                                        : '$currency${(list[i].variants[0].weightUnit)}',
                                    style: textmontserratsbold(),
                                  ),
                                ),
                                SizedBox(width: 3),
                                list[i].status != "active"
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          '$currency${list[i].variants[0].price}',//.toStringAsFixed(2)
                                          style: textmontserratsboldLine(),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      )
                    ])));
          },
        ),
      ],
    );
  }

  topDealsRow(titleTranslate, list, dealsType) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              titleTranslate,
              style: textBarlowMediumBlack(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AllDealsList(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        productsList: list,
                        currency: currency,
                        token: getTokenValue,
                        dealType: dealsType,
                        title: titleTranslate),
                  ),
                );
              },
              child: Text(
                "VIEW_ALL",
                style: textBarlowMediumPrimary(),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: list.length != null ? list.length : 0,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  if (list[i]['dealType'] == 'CATEGORY') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            catId: list[i]['categoryId'],
                            catTitle:
                                '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                            token: getTokenValue),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          productID: list[i]['productId'],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 15),
                  child: GFImageOverlay(
                    image: NetworkImage(list[i]['filePath'] == null
                        ? list[i]['imageUrl']
                        : Constants.imageUrlPath +
                            "/tr:dpr-auto,tr:w-500" +
                            list[i]['filePath']),
                    boxFit: BoxFit.cover,
                    color: Colors.black,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.40), BlendMode.darken),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                              '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textBarlowSemiBoldwbig()),
                          Text(
                            list[i]['dealPercent'].toString() + "% " + "OFF",
                            style: textBarlowRegularrwhsm(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  todayDealsRow(titleTranslate, list, dealsType) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              titleTranslate,
              style: textBarlowMediumBlack(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AllDealsList(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        productsList: list,
                        currency: currency,
                        token: getTokenValue,
                        dealType: dealsType,
                        title: titleTranslate),
                  ),
                );
              },
              child: Text(
                "VIEW_ALL",
                style: textBarlowMediumPrimary(),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length != null ? list.length : 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  if (list[i]['dealType'] == 'CATEGORY') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            catId: list[i]['categoryId'],
                            catTitle:
                                '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                            token: getTokenValue),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          productID: list[i]['productId'],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 15),
                  child: GFImageOverlay(
                    image: NetworkImage(
                      list[i]['filePath'] == null
                          ? list[i]['imageUrl']
                          : Constants.imageUrlPath +
                              "/tr:dpr-auto,tr:w-500" +
                              list[i]['filePath'],
                    ),
                    boxFit: BoxFit.cover,
                    color: Colors.black,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.40), BlendMode.darken),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(list[i]['dealPercent'].toString() + "% " + "OFF",
                              style: textoswaldboldwhite()),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textBarlowmediumsmallWhite(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      key: _scaffoldKeydrawer,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            isLoadingAllData = true;
            isBannerLoading = true;
            // getBannerData();
            // getAllDataMethod();
            _productsBloc.getProducts();
            _productsBloc.getCollection();
          });
        },
        child: (isLoadingAllData || isBannerLoading) &&
                // categoryList == null &&
                _products == null
                //&& dealList == null &&
                // topDealList == null &&
                // bannerList == null
            ? SquareLoader()
            : /*categoryList.length == 0 &&*/
            _products== null||
                    _products.length == 0
                    /*&& dealList.length == 0 &&
                    topDealList.length == 0 &&
                    bannerList.length == 0*/
                ? Center(
                    child: Image.asset('lib/assets/images/no-orders.png'),
                  )
                : SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          _collectionListings.length == 0
                              ? Container()
                              : SizedBox(height: 20),
                          _collectionListings.length == 0 ? Container() : banner(),
                          _collectionListings.length == 0
                              ? Container()
                              : SizedBox(height: 15),
                          _collectionListings.length == 0
                              ? Container()
                              : categoryRow(),
                          _collectionListings.length == 0 ? Container() : Divider(),
                          _collectionListings.length == 0
                              ? Container()
                              : SizedBox(height: 10),
                          // topDealList.length == 0
                          //     ? Container()
                          //     : topDealsRow(
                          //         MyLocalizations.of(context)
                          //             .getLocalizations("TOP_DEALS"),
                          //         topDealList,
                          //         "TopDeals"),
                          // topDealList.length == 0
                          //     ? Container()
                          //     : SizedBox(height: 10),
                          // topDealList.length == 0 ? Container() : Divider(),
                          // topDealList.length == 0
                          //     ? Container()
                          //     : SizedBox(height: 10),
                          productRow(
                              "Products",
                              _products),
                          _products!=null || _products.length == 0
                              ? Container()
                              : SizedBox(height: 10),
                          _products!=null || _products.length == 0 ? Container() : Divider(),
                          _products!=null || _products.length == 0
                              ? Container()
                              : SizedBox(height: 10),
                          /*dealList.length == 0
                              ? Container()
                              : todayDealsRow(
                                  MyLocalizations.of(context)
                                      .getLocalizations("DEALS_OF_THE_DAYS"),
                                  dealList,
                                  "TodayDeals"),
                          dealList.length == 0
                              ? Container()
                              : SizedBox(height: 10),
                          dealList.length == 0 ? Container() : Divider(),
                          dealList.length == 0
                              ? Container()
                              : SizedBox(height: 10),*/
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
