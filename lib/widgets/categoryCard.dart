import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  final Function onTap;
  final String imageUrl;
  CategoriesCard({
    Key key,
    @required this.onTap,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: imageUrl == null
            ? Container()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
