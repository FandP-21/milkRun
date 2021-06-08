import 'package:flutter/material.dart';
import 'package:groceryPro/model/AllProductResponseModel.dart';
import 'package:groceryPro/utils/constants.dart' as Constants;
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:groceryPro/networking/Response.dart';
import 'package:groceryPro/networking/bloc/ProductsBloc.dart';
import 'package:groceryPro/networking/repository/Repositories.dart';
import 'package:groceryPro/model/counterModel.dart';
import 'package:groceryPro/screens/drawer/drawer.dart';
import 'package:groceryPro/screens/tab/mycart.dart';
import 'package:groceryPro/screens/tab/profile.dart';
import 'package:groceryPro/screens/tab/saveditems.dart';
import 'package:groceryPro/screens/tab/searchitem.dart';
import 'package:groceryPro/screens/tab/store.dart';
import 'package:groceryPro/service/auth-service.dart';
import 'package:groceryPro/service/common.dart';
import 'package:groceryPro/service/localizations.dart';
import 'package:groceryPro/service/sentry-service.dart';
import 'package:groceryPro/style/style.dart';
import 'package:location/location.dart';
import 'package:groceryPro/widgets/loader.dart';


class Home extends StatefulWidget {
  final int currentIndex;
/*  final Map localizedValues;
  final String locale;*/
  Home({
    Key key,
    this.currentIndex,
  /*  this.locale,
    this.localizedValues,*/
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  bool currencyLoading = false,
      isCurrentLoactionLoading = false,
      getTokenValue = false;
  int currentIndex = 0, cartData;
  LocationData currentLocation;
  Location _location = new Location();
  String currency = "";

  var addressData;

  ProductsBloc _productsBloc;
  AllProductResponseModel _allProductResponseModel;

  void initState() {
    _productsBloc = ProductsBloc();
    _productsBloc.getProducts();
    _productsBloc.ordersStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Constants.onLoading(context);
            break;
          case Status.COMPLETED:
            print(event.message);
            Constants.stopLoader(context);
            // navigateToTab(context);
            _allProductResponseModel = event.data;
            break;
          case Status.ERROR:
            print(event.message);
            Constants.stopLoader(context);
            if (event.message == "Invalid Request: null") {
              Constants.showMyDialog("Invalid Credentials.", context);
            } else {
              Constants.showMyDialog(event.message, context);
            }
            break;
        }
      });
    });
    // if (widget.currentIndex != null) {
    //   if (mounted) {
    //     setState(() {
    //       currentIndex = widget.currentIndex;
    //     });
    //   }
    // }
    // getToken();
    // getResult();
    // getGlobalSettingsData();
    //
    // tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  getGlobalSettingsData() async {
    if (mounted) {
      setState(() {
        currencyLoading = true;
      });
    }
    LoginService.getLocationformation().then((onValue) async {
      if (mounted) {
        setState(() {
          currencyLoading = false;
        });
      }
      if (onValue['response_data']['currencySymbol'] == null) {
        await Common.setCurrency('\$');
        await Common.getCurrency().then((value) {
          currency = value;
        });
      } else {
        currency = onValue['response_data']['currencySymbol'];
        await Common.setCurrency(currency);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          currencyLoading = false;
          Common.setCurrency('\$');
        });
      }
    });
  }

  // getToken() async {
  //   await Common.getToken().then((onValue) {
  //     if (onValue != null) {
  //       if (mounted) {
  //         setState(() {
  //           getTokenValue = true;
  //         });
  //       }
  //     } else {
  //       if (mounted) {
  //         setState(() {
  //           getTokenValue = false;
  //         });
  //       }
  //     }
  //   }).catchError((error) {
  //     if (mounted) {
  //       setState(() {
  //         getTokenValue = false;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    if (tabController != null) tabController.dispose();
    super.dispose();
  }

  deliveryAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Search hear..",
                style: textBarlowRegularrBlacksm(),
              ),
              Text(
                addressData ?? "",
                overflow: TextOverflow.ellipsis,
                style: textAddressLocation(),
              )
            ],
          ),
        ),
      ],
    );
  }

  getResult() async {
    await Common.getCurrentLocation().then((address) async {
      if (address != null) {
        if (mounted) {
          setState(() {
            addressData = address;
          });
        }
      }
      currentLocation = await _location.getLocation();
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      if (mounted) {
        setState(() {
          addressData = first.addressLine;
          isCurrentLoactionLoading = false;
        });
      }
      await Common.setCurrentLocation(addressData);
      return first;
    });
  }

  _onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getTokenValue) {
      CounterModel().getCartDataCountMethod().then((res) {
        if (mounted) {
          setState(() {
            cartData = res;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          cartData = 0;
        });
      }
    }
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        title: Text("STORE"),//Text(MyLocalizations.of(context).getLocalizations("STORE")),
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Icon(
            const IconData(
              0xe90f,
              fontFamily: 'icomoon',
            ),
          ),
        ),
      ),
      BottomNavigationBarItem(
        title: Text("FAVORITE"),
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Icon(
            const IconData(
              0xe90d,
              fontFamily: 'icomoon',
            ),
          ),
        ),
      ),
      BottomNavigationBarItem(
        title: Text("MY CART"),
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GFIconBadge(
            child: Icon(
              const IconData(
                0xe911,
                fontFamily: 'icomoon',
              ),
            ),
            counterChild: (cartData == null || cartData == 0)
                ? Container()
                : GFBadge(
                    child: Text(
                      '${cartData.toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "bold",
                          fontSize: 11),
                    ),
                    shape: GFBadgeShape.circle,
                    color: Colors.red,
                    size: 25,
                  ),
          ),
        ),
      ),
      BottomNavigationBarItem(
        title: Text("PROFILE"),
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Icon(
            const IconData(
              0xe912,
              fontFamily: 'icomoon',
            ),
          ),
        ),
      ),
    ];

    List<Widget> _screens = [
      Store(
          _allProductResponseModel
        // locale: widget.locale,
        // localizedValues: widget.localizedValues,
      ),
      SavedItems(
        // locale: widget.locale,
        // localizedValues: widget.localizedValues,
      ),
      MyCart(
        // locale: widget.locale,
        // localizedValues: widget.localizedValues,
      ),
      Profile(
        // locale: widget.locale,
        // localizedValues: widget.localizedValues,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: currentIndex == 0
          ? GFAppBar(
              backgroundColor: bg,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: deliveryAddress(),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchItem(
                          // locale: widget.locale,
                          // localizedValues: widget.localizedValues,
                          currency: currency,
                          token: getTokenValue,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ],
            )
          : null,
      drawer: Drawer(
        child: DrawerPage(
          // locale: widget.locale,
          // localizedValues: widget.localizedValues,
          addressData: addressData ?? "",
        ),
      ),
      body: currencyLoading ? SquareLoader() : _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: primary,
        unselectedItemColor: Colors.white.withOpacity(0.50),
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        onTap: _onTapped,
        items: items,
      ),
    );
  }
}
