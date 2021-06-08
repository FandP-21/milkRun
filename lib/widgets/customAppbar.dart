import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppBarType {
  tabBarScreens,
  onlyTile,
  crossBack,
  crossBackTransparent,
  backArrow
}

class CustomAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final Widget titleWidget;
  final AppBarType appBarType;

  CustomAppBar({
    @required this.context,
    @required this.appBarType,
    this.titleWidget,
    this.titleText,
  });

  @override
  Color get backgroundColor => appBarType == AppBarType.crossBackTransparent
      ? Colors.transparent
      : Colors.white;

  @override
  bool get centerTitle => true;

  @override
  List<Widget> get actions => [];

  @override
  double get elevation => 1;

  @override
  Widget get leading => appBarType == AppBarType.tabBarScreens
      ? IconButton(
          onPressed: () {
            //TODO: show ProfileScreen
          },
          icon: Icon(
            CupertinoIcons.person_alt_circle,
          ),
        )
      : appBarType == AppBarType.onlyTile
          ? Container()
          : appBarType == AppBarType.crossBack
              ? IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    CupertinoIcons.multiply,
                  ))
              : appBarType == AppBarType.crossBackTransparent
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Transform.scale(
                        scale: 1,
                        child: Container(
                          height: 30,
                          width: 30,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              CupertinoIcons.back,
                              size: 14,
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 8)
                              ]),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        CupertinoIcons.back,
                      ));

  @override
  Widget get title =>
      titleWidget ??
      Text(
        titleText ?? "",
      );
}
