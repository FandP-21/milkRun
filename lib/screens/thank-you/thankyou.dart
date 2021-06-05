import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:groceryPro/screens/home/home.dart';
import 'package:groceryPro/screens/orders/orders.dart';
import 'package:groceryPro/service/localizations.dart';

import 'package:groceryPro/style/style.dart';

class Thankyou extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Thankyou({Key key, this.locale, this.localizedValues});
  @override
  _ThankyouState createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('lib/assets/images/thank-you.png'),
            SizedBox(height: 10.0),
            Text(
              "ORDER_PLACED",
              textAlign: TextAlign.center,
              style: textbarlowMediumBlack(),
            ),
            SizedBox(height: 13.0),
            Text(
              "THANK_YOU",
              textAlign: TextAlign.center,
              style: textbarlowMediumlgBlack(),
            ),
            SizedBox(height: 30.0),
            GFButton(
              onPressed: () {
                var reuslt = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Orders(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                    ),
                  ),
                );
                reuslt.then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        // locale: widget.locale,
                        // localizedValues: widget.localizedValues,
                        currentIndex: 0,
                      ),
                    ),
                    (Route<dynamic> route) => false));
              },
              color: Colors.black,
              child: Text(
                "ORDERS",
                style: textbarlowMediumPrimary(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
