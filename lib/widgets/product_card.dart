import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final totalScreenHeight = mediaQuery.size.height;

    ////// STYLING //////
    const productTitleStyle = TextStyle(
      color: const Color(0xFFFFFFFF),
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.w500,
      shadows: [
        Shadow(
          color: const Color(0xFF000000),
          blurRadius: 8,
        ),
        Shadow(
          color: const Color(0xFF000000),
          blurRadius: 8,
        ),
      ],
    );

    const productPriceStyle = TextStyle(
      color: const Color(0xFFFFFFFF),
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: const Color(0xFF000000),
          blurRadius: 8,
        ),
      ],
    );
    ////// END OF STYLING //////

    ////// CARD BOTTOM BAR //////
    final cardBottomBar = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFf5d9ff).withOpacity(0.65),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.3),
            ),
          ],
        ),
        child: Column(
          children: [

            ////// TITLE LABEL //////
            Container(
              height: totalScreenHeight * 0.035,
              child: FittedBox(
                child: Text(
                  product.title,
                  style: productTitleStyle,
                ),
              ),
              alignment: Alignment.bottomLeft,
            ),

            ////// PRICE LABEL //////
            Container(
              height: totalScreenHeight * 0.035,
              child: FittedBox(
                child: Text(
                  'R\$ ${product.price}',
                  style: productPriceStyle,
                ),
              ),
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
    ////// END OF CARD BOTTOM BAR //////

    ////// PRODUCT CARD //////
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      elevation: 12,
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: totalScreenHeight * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          cardBottomBar
        ],
      ),
    );
    ////// END OF PRODUCT CARD //////
  }
}
