import 'package:flutter/material.dart';
import 'package:groceryPro/screens/authe/login.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

// https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/orders.json
var baseUrl = 'https://$API_KEY:$API_PASSWORD@$STORE_NAME.myshopify.com/admin/api/$API_VERSION';

const String AUTHTOKEN = "auth_token";

const String NO_INTERNET = "No Internet";

//api end points
const String GET_ALL_PRODUCTS = "/products";//List all products

//auth keys
const String API_KEY = "cd5845fe0a28f4a78b0e0158621ec405";
const String API_PASSWORD = "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";
const String STORE_NAME = "milkrun-rabbit";
const String API_VERSION = "2021-04";




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
              Lottie.asset('lib/assets/loader.json', width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height)
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
                        Login()), (Route<dynamic> route) => false);
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
