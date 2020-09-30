import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final totalScreenHeight = mediaQuery.size.height;
    final currentScaffoldState = Scaffold.of(context);

    ////// STYLING //////
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

    ////// PRODUCT CARD //////
    final productCard = Card(
      elevation: 12,
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
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

    ////// GESTURES WIDGETS //////
    return Dismissible(
      key: ValueKey(product.id),
      // TODO: implement confirmDismiss function
      confirmDismiss: (_) async {
        _showSnackBar(
          currentScaffoldState,
          'Salvo na sacolinha: ${product.title}',
        );
        return false;
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Theme.of(context).accentColor,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag, size: 40),
            Text(
              'Salvar na sacolinha',
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      // TODO: implement onTap function
      child: GestureDetector(
        child: productCard,
        onDoubleTap: () {
          _showSnackBar(currentScaffoldState, 'Item curtido: ${product.title}');
        },
      ),
    );
  }

  ////// METHODS //////
  void _showSnackBar(ScaffoldState scaffold, String content) {
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
