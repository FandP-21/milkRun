import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:groceryPro/model/addToCart.dart';
import 'package:groceryPro/screens/authe/login.dart';
import 'package:groceryPro/service/auth-service.dart';
import 'package:groceryPro/service/common.dart';
import 'package:groceryPro/service/constants.dart';
import 'package:groceryPro/service/localizations.dart';
import 'package:groceryPro/style/style.dart';
import 'package:groceryPro/service/cart-service.dart';
import 'package:groceryPro/service/sentry-service.dart';
import 'package:groceryPro/screens/checkout/checkout.dart';
import 'package:groceryPro/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class MyCart extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  MyCart({Key key, this.locale, this.localizedValues}) : super(key: key);
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoadingCart = false,
      isGetTokenLoading = false,
      isUpdating = false,
      isMinAmountCheckLoading = false,
      isCheckProductAvailableOrNot = false;
  String token, currency;
  String quantityUpdateType = '+';
  Map cartItem;
  double bottomBarHeight = 150;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var minAmout;
  @override
  void initState() {
    getToken();
    checkMinOrderAmount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkMinOrderAmount() async {
    if (mounted) {
      setState(() {
        isMinAmountCheckLoading = true;
      });
    }
    await LoginService.getLocationformation().then((onValue) {
      if (mounted) {
        setState(() {
          minAmout = onValue['response_data'];
          isMinAmountCheckLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          minAmout = null;
          isMinAmountCheckLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
            token = onValue;
            getCartItems();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void _incrementCount(i) {
    quantityUpdateType = '+';

    if (mounted)
      setState(() {
        cartItem['products'][i]['quantity']++;
        updateCart(i);
      });
  }

  void _decrementCount(i) {
    quantityUpdateType = '-';
    if (cartItem['products'][i]['quantity'] > 1) {
      if (mounted) {
        setState(() {
          cartItem['products'][i]['quantity']--;
          updateCart(i);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          deleteCart(i);
        });
      }
    }
  }

  // update cart
  updateCart(i) async {
    Map<String, dynamic> body = {
      'unit': cartItem['products'][i]['unit'],
      'productId': cartItem['products'][i]['productId'],
      'quantity': cartItem['products'][i]['quantity']
    };
    if (mounted) {
      setState(() {
        isUpdating = true;
        cartItem['products'][i]['isQuantityUpdating'] = true;
      });
    }
    await AddToCart.addAndUpdateProductMethod(body).then((onValue) {
      if (mounted) {
        setState(() {
          isUpdating = false;
          cartItem = onValue['response_data'];
          cartItem['products'][i]['quantity'] =
              cartItem['products'][i]['quantity'];
          cartItem['products'][i]['isQuantityUpdating'] = false;
        });
      }
      if (onValue['message'] != null) {
        showSnackbar(onValue['message'] ?? "");
      }

      if (onValue['response_data'] is Map) {
        Common.setCartData(onValue['response_data']);
      } else {
        Common.setCartData(null);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isUpdating = false;
          cartItem['products'][i]['quantity']--;
          cartItem['products'][i]['quantity'] =
              cartItem['products'][i]['quantity'];
          cartItem['products'][i]['isQuantityUpdating'] = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // get to cart
  getCartItems() async {
    if (mounted) {
      setState(() {
        isLoadingCart = true;
      });
    }
    await CartService.getProductToCart().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          isLoadingCart = false;
        });
      }
      if (onValue['response_data'] is Map &&
          onValue['response_data']['products'] != [] &&
          mounted) {
        Common.setCartData(onValue['response_data']);

        setState(() {
          cartItem = onValue['response_data'];
          if (cartItem['grandTotal'] != null) {
            bottomBarHeight = 150;
            if (cartItem['deliveryCharges'] != 0) {
              bottomBarHeight = bottomBarHeight + 20;
            }
            if (cartItem['tax'] != 0) {
              bottomBarHeight = bottomBarHeight + 20;
            }
            if (cartItem['couponInfo'] != null) {
              bottomBarHeight = bottomBarHeight + 20;
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            Common.setCartData(null);
            cartItem = null;
            isLoadingCart = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cartItem = null;
          isLoadingCart = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  //delete from cart
  deleteCart(i) async {
    await CartService.deleteDataFromCart(cartItem['products'][i]['productId'])
        .then((onValue) {
      if (onValue['response_data'] is Map &&
          onValue['response_data']['products'].length == 0 &&
          mounted) {
        setState(() {
          cartItem = null;
          deleteAllCart();
          Common.setCartData(null);
        });
      } else {
        setState(() {
          getCartItems();
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          cartItem = null;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  deleteAllCart() async {
    await CartService.deleteAllDataFromCart().then((onValue) {
      Common.setCartData(null);
      if (mounted) {
        setState(() {
          cartItem = null;
          getCartItems();
        });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  checkMinOrderAmountCondition() async {
    if (minAmout['minimumOrderAmountToPlaceOrder'] == null) {
      minAmout['minimumOrderAmountToPlaceOrder'] = 0.0;
    }
    if (cartItem['subTotal'] >= minAmout['minimumOrderAmountToPlaceOrder']) {
      checkProductAvailableOrNot();
    } else {
      showError(MyLocalizations.of(context).getLocalizations("MIN_AMOUNT_MEG") +
          "($currency${minAmout['minimumOrderAmountToPlaceOrder'].toString()})");
    }
  }

  checkProductAvailableOrNot() async {
    if (mounted) {
      setState(() {
        isCheckProductAvailableOrNot = true;
      });
    }
    CartService.checkCartVerifyOrNot().then((response) {
      if (mounted) {
        setState(() {
          isCheckProductAvailableOrNot = false;
        });
      }
      var result = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Checkout(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
            id: cartItem['_id'].toString(),
          ),
        ),
      );
      result.then((value) {
        getCartItems();
      });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCheckProductAvailableOrNot = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  showError(responseData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            responseData,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MyLocalizations.of(context).getLocalizations("OK")),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      key: _scaffoldKey,
      appBar: isGetTokenLoading || isMinAmountCheckLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  title: Text(
                    MyLocalizations.of(context).getLocalizations("MY_CART"),
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
      body: isGetTokenLoading || isMinAmountCheckLoading
          ? SquareLoader()
          : token == null
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isCart: true,
                )
              : cartItem == null
                  ? Center(
                      child: Image.asset('lib/assets/images/no-orders.png'),
                    )
                  : Container(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 20.0, right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      cartItem == null
                                          ? Text(
                                              '0 ' +
                                                  MyLocalizations.of(context)
                                                      .getLocalizations("ITEM"),
                                              style: textBarlowMediumBlack(),
                                            )
                                          : Text(
                                              '(${cartItem['products'].length}) ' +
                                                  MyLocalizations.of(context)
                                                      .getLocalizations(
                                                          "ITEMS"),
                                              style: textBarlowMediumBlack(),
                                            ),
                                      InkWell(
                                        onTap: () {
                                          deleteAllCart();
                                        },
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getLocalizations("CLEAR_CART"),
                                          style: textBarlowMediumBlack(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cartItem == null
                                      ? 0
                                      : cartItem['products'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7F7F7),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              height: 90,
                                              width: 117,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.10),
                                                    blurRadius: 5,
                                                  )
                                                ],
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: cartItem['products'][i]
                                                                  [
                                                                  'filePath'] ==
                                                              null &&
                                                          cartItem['products']
                                                                      [i][
                                                                  'imageUrl'] ==
                                                              null
                                                      ? AssetImage(
                                                          'lib/assets/images/no-orders.png')
                                                      : NetworkImage(
                                                          cartItem['products']
                                                                          [i][
                                                                      'filePath'] ==
                                                                  null
                                                              ? cartItem[
                                                                      'products']
                                                                  [
                                                                  i]['imageUrl']
                                                              : Constants
                                                                      .imageUrlPath +
                                                                  "/tr:dpr-auto,tr:w-500" +
                                                                  cartItem['products']
                                                                          [i][
                                                                      'filePath'],
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            flex: 6,
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  cartItem['products'][i]
                                                          ['productName'] ??
                                                      " ",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      textBarlowRegularBlack(),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      currency,
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    ),
                                                    Text(
                                                      cartItem['products'][i][
                                                                  'productTotal']
                                                              .toDouble()
                                                              .toStringAsFixed(
                                                                  2)
                                                              .toString() ??
                                                          "",
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    ),
                                                    SizedBox(width: 3),
                                                    cartItem['products'][i]
                                                            ['isDealAvailable']
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            child: Text(
                                                              '$currency${((cartItem['products'][i]['price']) * (cartItem['products'][i]['quantity'])).toDouble().toStringAsFixed(2)}',
                                                              style:
                                                                  barlowregularlackstrike(),
                                                            ),
                                                          )
                                                        : Container(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                        " / " +
                                                            cartItem['products']
                                                                    [i]['unit']
                                                                .toString(),
                                                        style:
                                                            barlowregularlack(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                cartItem['products'][i][
                                                            'isDealAvailable'] ==
                                                        true
                                                    ? Text(
                                                        MyLocalizations.of(
                                                                    context)
                                                                .getLocalizations(
                                                                    "DEAL") +
                                                            " " +
                                                            (cartItem['products']
                                                                        [i][
                                                                    'dealPercent'])
                                                                .toString() +
                                                            "% " +
                                                            MyLocalizations.of(
                                                                    context)
                                                                .getLocalizations(
                                                                    "OFF"),
                                                        style:
                                                            barlowregularlack(),
                                                        // textBarlowRegularBlack(),
                                                      )
                                                    : Text("")
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              height: 110,
                                              width: 43,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF0F0F0),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(22),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (cartItem['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                null ||
                                                            cartItem['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                false) {
                                                          _incrementCount(i);
                                                        }
                                                      },
                                                      child: cartItem['products']
                                                                          [i][
                                                                      'isQuantityUpdating'] ==
                                                                  true &&
                                                              quantityUpdateType ==
                                                                  '+'
                                                          ? GFLoader(
                                                              type: GFLoaderType
                                                                  .ios,
                                                              size: 35,
                                                            )
                                                          : Icon(
                                                              Icons.add,
                                                            ),
                                                    ),
                                                  ),
                                                  cartItem['products'][i]
                                                              ['quantity'] ==
                                                          null
                                                      ? Text('0')
                                                      : Text(
                                                          '${cartItem['products'][i]['quantity']}',
                                                          style:
                                                              textBarlowRegularBlack(),
                                                        ),
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: cartItem['products']
                                                                          [i][
                                                                      'isQuantityUpdating'] ==
                                                                  true &&
                                                              quantityUpdateType ==
                                                                  '-'
                                                          ? primary
                                                          : Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (cartItem['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                null ||
                                                            cartItem['products']
                                                                        [i][
                                                                    'isQuantityUpdating'] ==
                                                                false) {
                                                          _decrementCount(i);
                                                        }
                                                      },
                                                      child: cartItem['products']
                                                                          [i][
                                                                      'isQuantityUpdating'] ==
                                                                  true &&
                                                              quantityUpdateType ==
                                                                  '-'
                                                          ? GFLoader(
                                                              type: GFLoaderType
                                                                  .ios,
                                                              size: 35,
                                                            )
                                                          : Icon(
                                                              Icons.remove,
                                                              color: primary,
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
      bottomNavigationBar: isGetTokenLoading ||
              isMinAmountCheckLoading ||
              isLoadingCart
          ? SquareLoader()
          : token == null || cartItem == null
              ? Container(height: 1)
              : Container(
                  height: bottomBarHeight,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("SUB_TOTAL"),
                              style: textBarlowRegularBlack(),
                            ),
                            new Text(
                              '$currency${cartItem['subTotal'].toDouble().toStringAsFixed(2)}',
                              style: textbarlowBoldsmBlack(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      cartItem['tax'] == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset('lib/assets/icons/sale.png'),
                                      SizedBox(width: 5),
                                      cartItem['taxInfo'] == null
                                          ? new Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations("TAX"),
                                              style: textBarlowRegularBlack(),
                                            )
                                          : new Text(
                                              MyLocalizations.of(context)
                                                      .getLocalizations("TAX") +
                                                  " (" +
                                                  cartItem['taxInfo']
                                                      ['taxName'] +
                                                  " " +
                                                  cartItem['taxInfo']['amount']
                                                      .toString() +
                                                  "%)",
                                              style: textBarlowRegularBlack(),
                                            ),
                                    ],
                                  ),
                                  new Text(
                                    '$currency${cartItem['tax'].toDouble().toStringAsFixed(2)}',
                                    style: textbarlowBoldsmBlack(),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 6),
                      cartItem['couponCode'] == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    MyLocalizations.of(context)
                                            .getLocalizations(
                                                "COUPON_APPLIED") +
                                        " (" +
                                        "${MyLocalizations.of(context).getLocalizations("DISCOUNT")}"
                                            ")",
                                    style: textBarlowRegularBlack(),
                                  ),
                                  new Text(
                                    '$currency${cartItem['couponAmount'].toDouble().toStringAsFixed(2)}',
                                    style: textbarlowBoldsmBlack(),
                                  ),
                                ],
                              ),
                            ),
                      cartItem['couponCode'] == null
                          ? Container()
                          : SizedBox(height: 6),
                      cartItem['deliveryCharges'] == 0 &&
                              cartItem['deliveryAddress'] != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("DELIVERY_CHARGES"),
                                    style: textBarlowRegularBlack(),
                                  ),
                                  new Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("FREE"),
                                    style: textbarlowBoldsmBlack(),
                                  ),
                                ],
                              ),
                            )
                          : cartItem['deliveryCharges'] == 0
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        MyLocalizations.of(context)
                                            .getLocalizations(
                                                "DELIVERY_CHARGES"),
                                        style: textBarlowRegularBlack(),
                                      ),
                                      new Text(
                                        '$currency${cartItem['deliveryCharges'].toDouble().toStringAsFixed(2)}',
                                        style: textbarlowBoldsmBlack(),
                                      ),
                                    ],
                                  ),
                                ),
                      SizedBox(height: 10),
                      Container(
                        height: 55,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: primary,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.29),
                                blurRadius: 6)
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              width: 115,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    MyLocalizations.of(context)
                                        .getLocalizations("TOTAL"),
                                    style: textBarlowRegularWhite(),
                                  ),
                                  new Text(
                                    '$currency${cartItem['grandTotal'].toDouble().toStringAsFixed(2)}',
                                    style: textbarlowBoldWhite(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: RawMaterialButton(
                                onPressed: checkMinOrderAmountCondition,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      isCheckProductAvailableOrNot
                                          ? GFLoader(
                                              type: GFLoaderType.ios,
                                            )
                                          : Text(""),
                                      Text(
                                        MyLocalizations.of(context)
                                            .getLocalizations("CHECKOUT"),
                                        style: textbarlowRegularWhite(),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
