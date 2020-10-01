import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

const productTitleStyle = TextStyle(
  color: const Color(0xFFFFFFFF),
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
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: const Color(0xFF000000),
      blurRadius: 8,
    ),
  ],
);

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalScreenHeight = MediaQuery.of(context).size.height;
    final product = Provider.of<Product>(context, listen: false);

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
            BoxShadow(color: const Color(0xFF000000).withOpacity(0.3))
          ],
        ),
        child: Column(
          children: [
            ////// TITLE LABEL //////
            Container(
              height: totalScreenHeight * 0.035,
              alignment: Alignment.bottomLeft,
              child: FittedBox(
                child: Text(product.title, style: productTitleStyle),
              ),
            ),

            ////// PRICE AND ICONS LABEL //////
            Container(
              height: totalScreenHeight * 0.035,
              alignment: Alignment.bottomLeft,
              child: FittedBox(
                child: Consumer<Product>(
                  builder: (_, product, child) {
                    child =
                        Text('R\$ ${product.price}', style: productPriceStyle);

                    final List<Widget> icons = [];

                    if (product.isFavorite) {
                      icons.add(Icon(Icons.favorite, color: Colors.pink));
                      icons.add(SizedBox(width: 10));
                    }

                    return Row(children: [...icons, child]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ////// CARD //////
    final card = Card(
      elevation: 12,
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: totalScreenHeight * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(product.imageUrl), fit: BoxFit.cover)),
          ),
          cardBottomBar
        ],
      ),
    );

    return card;
  }
}
