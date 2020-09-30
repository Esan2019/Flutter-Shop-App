import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductOverview extends StatelessWidget {
  final Product product;
  const ProductOverview(this.product);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final totalScreenHeight = mediaQuery.size.height;
    final totalScreenWidth = mediaQuery.size.width;
    const defaultWhiteColor = const Color(0xFFebebeb);

    ////// FAVORITE BUTTON //////
    final favoriteButton = Positioned(
      bottom: 0,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: totalScreenHeight * 0.08,
        child: IconButton(
          icon: Icon(Icons.favorite),
          color: defaultWhiteColor,
          splashRadius: 0.01,
          // TODO: implement onPressed function
          onPressed: () {},
        ),
      ),
    );

    ////// ADD TO CART BUTTON //////
    final addToCartButton = GestureDetector(
      // TODO: implement onTap function
      onTap: () {},
      child: Container(
        height: totalScreenHeight * 0.08,
        width: totalScreenWidth * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(
                Icons.shopping_bag,
                color: defaultWhiteColor,
              ),
              Text(
                'Salvar na sacolinha',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: defaultWhiteColor,
                ),
              ),
            ]),
            Text(
              '(R\$ ${product.price})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: defaultWhiteColor,
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ////// PRODUCT IMAGE //////
            Container(
              height: totalScreenHeight * 0.68,
              width: totalScreenWidth,
              child: Stack(
                children: [
                  Container(
                    height: totalScreenHeight * 0.64,
                    width: totalScreenWidth,
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                  ),
                  favoriteButton,
                ],
              ),
            ),
            SizedBox(height: totalScreenHeight * 0.005),

            ////// PRODUCT TITLE //////
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              // 0.755
              height: totalScreenHeight * 0.07,
              child: FittedBox(
                child: Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Spacer(),
            addToCartButton,
            SizedBox(height: totalScreenHeight * 0.01)
          ],
        ),
      ),
    );
  }
}
