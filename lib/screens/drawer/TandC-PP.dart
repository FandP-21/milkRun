import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../service/auth-service.dart';
import '../../service/sentry-service.dart';
import '../../style/style.dart';
import '../../widgets/loader.dart';

SentryError sentryError = new SentryError();

class TandCandPrivacyPolicy extends StatefulWidget {
  TandCandPrivacyPolicy(
      {Key key, this.locale, this.localizedValues, this.endPoint, this.title})
      : super(key: key);

  final Map localizedValues;
  final String locale, endPoint, title;

  @override
  _TandCandPrivacyPolicyState createState() => _TandCandPrivacyPolicyState();
}

class _TandCandPrivacyPolicyState extends State<TandCandPrivacyPolicy> {
  bool isTandCandPPloading = false;
  var data;

  @override
  void initState() {
    getAboutUsInfo();
    super.initState();
  }

  getAboutUsInfo() {
    if (mounted) {
      setState(() {
        isTandCandPPloading = true;
      });
    }
    LoginService.tandCandPandPMethod(widget.endPoint).then((value) {
      print(value);
      try {
        if (mounted) {
          setState(() {
            data = value['response_data']['description'];
            isTandCandPPloading = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isTandCandPPloading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isTandCandPPloading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: textBarlowRegularrBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isTandCandPPloading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: data,
                  ),
                ),
              ],
            ),
    );
  }
}
