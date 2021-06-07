import 'package:admin/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

var baseUrl = 'https://337a6c0d7f46.ngrok.io';

const String AUTHTOKEN = "auth_token";

const String NO_INTERNET = "No Internet";

//api end points
const String SING_IN = "/v1/auth/backend-signin";//Admin login

//user
const String GET_ALL_USER = "/v1/user"; //List user by admin
const String CREATE_USER = "/v1/user"; //Create new user by admin
const String GET_USER_BY_ID = "/v1/user/{id}"; //Create new user by admin
const String DELETE_USER_BY_ID = "/v1/user/"; //Delete user by admin
const String ACTIVE_DEACTIVE_USER = "/v1/user/active-deactive-user/"; //Enable disable user by admin

//category
const String GET_ALL_CATEGORY = "/v1/category"; //List category by admin
const String CREATE_CATEGORY = "/v1/category"; //Create new category by admin
const String DELETE_CATEGORY = "/v1/category/"; //Delete category by admin
const String UPDATE_CATEGORY = "/v1/category/"; //update category by admin

//category
const String GET_ALL_PRODUCTS = "/v1/products"; //List products by admin and reseller
const String CREATE_PRODUCTS = "/v1/products"; //Create new products by admin and reseller
const String DELETE_PRODUCTS = "/v1/products/"; //Delete products by admin and reseller
const String UPDATE_PRODUCTS = "/v1/products/"; //update products by admin and reseller


void onLoading(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    // background color
    barrierDismissible: false,
    // should dialog be dismissed when tapped outside
    barrierLabel: "Dialog",
    // label for barrier
    transitionDuration: Duration(milliseconds: 400),
    // how long it takes to popup dialog after button click
    pageBuilder: (_, __, ___) {
      // your widget implementation
      return SizedBox.expand(
        // makes widget fullscreen
        child: Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset('assets/loader.json', width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height)
            ],
          ),
        ),
      );
    },
  );
}

void stopLoader(BuildContext context) {
  Navigator.pop(context);
}

Future<void> showMyDialog(String msg, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Alert',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                msg,
                style: TextStyle(
                    color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: FlatButton(
                color: primaryColor,
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                ),
                onPressed: () async {
                  if(msg.contains("Unauthorised")){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();

                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        LoginPage()), (Route<dynamic> route) => false);
                  }else{
                    Navigator.of(context).pop();
                  }

                },
              ),
            ),
          )
        ],
      );
    },
  );
}
