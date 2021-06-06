import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';

import '../../service/auth-service.dart';
import '../../service/localizations.dart';
import '../../service/sentry-service.dart';
import '../../style/style.dart';
import '../../widgets/loader.dart';


class AboutUs extends StatefulWidget {
  AboutUs({Key key, this.locale, this.localizedValues}) : super(key: key);

  final Map localizedValues;
  final String locale;

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isAboutUsData = false, isBusinessInfoData = false;
  var aboutUs, businessInfo;

  @override
  void initState() {
    getAboutUsInfo();
    getBusinesInfo();
    super.initState();
  }

  getAboutUsInfo() {
    if (mounted) {
      setState(() {
        isAboutUsData = true;
      });
    }
    LoginService.aboutUs().then((value) {
      try {
        if (mounted) {
          setState(() {
            aboutUs = value['response_data']['description'];
            isAboutUsData = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isAboutUsData = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isAboutUsData = false;
        });
      }
    });
  }

  getBusinesInfo() {
    if (mounted) {
      setState(() {
        isBusinessInfoData = true;
      });
    }
    LoginService.businessInfo().then((value) {
      try {
        if (mounted) {
          setState(() {
            businessInfo = value['response_data'];
            isBusinessInfoData = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isBusinessInfoData = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isBusinessInfoData = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: textBarlowRegularrBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isAboutUsData || isBusinessInfoData
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: GFAvatar(
                      backgroundImage: AssetImage("lib/assets/logo.png"),
                      radius: 60,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15.0),
                  child: Text(
                    "Description",
                    style: textBarlowMediumBlack(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(data: aboutUs),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 15.0),
                  child: Text(
                    "Store",
                    style: textBarlowMediumBlack(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15),
                  child: Text(businessInfo['storeName'].toString()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 15.0),
                  child: Text(
                    "Location",
                    style: textBarlowMediumBlack(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15),
                  child: Text(businessInfo['officeLocation'].toString()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 15.0),
                  child: Text(
                    "Address",
                    style: textBarlowMediumBlack(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15),
                  child: Text(businessInfo['address']),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 15.0),
                  child: Text(
                    "Contact Number",
                    style: textBarlowMediumBlack(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15),
                  child: Text(businessInfo['phoneNumber'].toString()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15, right: 15.0),
                  child: Text(
                    "Email",
                    style: textBarlowMediumBlack(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15),
                  child: Text(businessInfo['email']),
                ),
              ],
            ),
    );
  }
}
