import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryPro/utils/colorConstants.dart';

class ProductCard extends StatelessWidget {
  final Function onTap;
  final String imageUrl;
  final String productName;
  final String price;
  //Scale can be per Kg or each
  final String scale;

  ProductCard({
    Key key,
    @required this.onTap,
    @required this.imageUrl,
    @required this.productName,
    @required this.price,
    @required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 168,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [_getImage(), _getRoundAddButton()],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _getInfoColumn(context),
            )
          ],
        ),
      ),
    );
  }

  Container _getImage() {
    return Container(
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: imageUrl == null
          ? Container()
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
    );
  }

  Positioned _getRoundAddButton() {
    return Positioned(
      right: 0,
      bottom: -15,
      child: Container(
        padding: EdgeInsets.zero,
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                color: Colors.black12,
                spreadRadius: 2,
                offset: Offset(0, 2))
          ],
        ),
        child: CircleAvatar(
          backgroundColor: AppColors.neutralWhite,
          foregroundColor: AppColors.neutralBlack,
          child: Icon(
            Icons.add_rounded,
            size: 24,
          ),
        ),
      ),
    );
  }

  Column _getInfoColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          maxLines: 2,
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Text(
              price,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(width: 4),
            Text(
              scale,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        )
      ],
    );
  }
}
