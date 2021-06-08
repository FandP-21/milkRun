import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryPro/widgets/customAppbar.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        appBarType: AppBarType.tabBarScreens,
      ),
      body: Container(
        child: Center(
          child: Image.asset(
            'lib/assets/icons/chat.png',
            color: Colors.black,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
