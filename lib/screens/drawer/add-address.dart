import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'package:groceryPro/service/localizations.dart';
import 'package:groceryPro/style/style.dart';
import 'package:groceryPro/service/sentry-service.dart';
import 'package:groceryPro/service/address-service.dart';
import 'package:location/location.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';

SentryError sentryError = new SentryError();

class AddAddress extends StatefulWidget {
  const AddAddress(
      {Key key,
      this.currentLocation,
      this.isCheckout,
      this.isProfile,
      this.pickedLocation,
      this.updateAddressID,
      this.locale,
      this.localizedValues})
      : super(key: key);
  final bool isCheckout, isProfile;
  // final LocationResult pickedLocation;
  final PlacePickerResult pickedLocation;
  final Map<String, dynamic> updateAddressID;
  final LocationData currentLocation;
  final Map localizedValues;
  final String locale;

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var addressData;
  LocationData currentLocation;
  bool isAddAddressLoading = false;
  StreamSubscription<LocationData> locationSubscription;
  int selectedAddressType = 0;
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    addressController.text = widget.pickedLocation.address;

    super.initState();
  }

  List<String> addressType = ['HOME', "WORK", "OTHERS"];
  Map<String, dynamic> address = {
    "location": {},
    "address": null,
    "flatNo": null,
    "apartmentName": null,
    "landmark": null,
    "postalCode": null,
    "mobileNumber": 0,
    "addressType": null
  };
  addAddress() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (mounted) {
        setState(() {
          isAddAddressLoading = true;
        });
      }

      var location = {
        "latitude": widget.pickedLocation.latLng.latitude,
        "longitude": widget.pickedLocation.latLng.longitude
      };
      address['address'] = addressController.text;
      address['location'] = location;
      address['addressType'] = addressType[selectedAddressType];
      AddressService.addAddress(address).then((onValue) {
        if (mounted) {
          setState(() {
            showSnackbar(onValue['response_data']);
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context);
              addressController.clear();
            });
            isAddAddressLoading = false;
          });
        }
      }).catchError((onError) {
        if (mounted) {
          setState(() {
            isAddAddressLoading = false;
          });
        }
        sentryError.reportError(onError, null);
      });
    }
  }

  setSelectedRadio(int val) async {
    if (mounted) {
      setState(() {
        selectedAddressType = val;
      });
    }
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    if (locationSubscription != null && locationSubscription is Stream)
      locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "ADD_NEW_ADDRESS",
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "LOCATION",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      maxLines: 3,
                      controller: addressController,
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        counterText: "",
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Color(0xFFF44242),
                        ),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "ENTER_LOCATION";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['address'] = addressController.text;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "HOUSE_FLAT_BLOCK_NUMBER",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    maxLength: 14,
                    style: textBarlowRegularBlack(),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "ENTER_HOUSE_FLAT_BLOCK_NUMBER";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['flatNo'] = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "APARTMENT_NAME",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Color(0xFFF44242),
                        ),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "ENTER_APARTMENT_NAME";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['apartmentName'] = value;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "LANDMARK",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Color(0xFFF44242),
                        ),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "ENTER_LANDMARK";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['landmark'] = value;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "POSTAL_CODE",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        counterText: "",
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Color(0xFFF44242),
                        ),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "ENTER_POSTAL_CODE";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['postalCode'] = value;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "CONTACT_NUMBER",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    maxLength: 15,
                    style: labelStyle(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "ENTER_CONTACT_NUMBER";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['mobileNumber'] = int.parse(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "ADDRESS_TYPE",
                        style: textbarlowRegularBlack(),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      addressType.length == null ? 0 : addressType.length,
                  itemBuilder: (BuildContext context, int i) {
                    String type;
                    if (addressType[i] == 'HOME') {
                      type =
                      "HOME";
                    } else if (addressType[i] == 'WORK') {
                      type =
                      "WORK";
                    } else if (addressType[i] == 'OTHERS') {
                      type = "OTHERS";
                    } else {
                      type = addressType[i];
                    }

                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: i,
                            groupValue: selectedAddressType,
                            activeColor: primary,
                            onChanged: (value) {
                              setSelectedRadio(value);
                            },
                          ),
                          Text(type),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.29), blurRadius: 5)
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                    ),
                    child: GFButton(
                      color: primary,
                      onPressed: () {
                        addAddress();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "SUBMIT",
                            style: textBarlowRegularrBlack(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          isAddAddressLoading
                              ? GFLoader(
                                  type: GFLoaderType.ios,
                                )
                              : Text("")
                        ],
                      ),
                      textStyle: textBarlowRegularrBlack(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
