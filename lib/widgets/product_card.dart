import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

import '../models/product.dart';
import '../routes_handler.dart';

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
  final Product product;
  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final totalScreenHeight = MediaQuery.of(context).size.height;
    final productsProvider = Provider.of<Products>(context);

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
                child: Row(
                  children: [
                    ...getIcons(product),
                    Text('R\$ ${product.price}', style: productPriceStyle)
                  ],
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

    final cardWrappedWithGestures = Dismissible(
      key: ValueKey(product.id),
      // TODO: implement confirmDismiss function
      confirmDismiss: (_) async {
        _showSnackBar(
            Scaffold.of(context), 'Salvo na sacolinha: ${product.title}');
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
            Text('Salvar na sacolinha',
                style: TextStyle(fontWeight: FontWeight.w500))
          ],
        ),
      ),
      child: GestureDetector(
        child: card,
        onTap: () => _navigateToOverviewScreen(context, product),
        onDoubleTap: productsProvider.toggleFavoriteStatus(product),
      ),
    );

    return cardWrappedWithGestures;
  }
}

List<Widget> getIcons(Product product) {
  final List<Widget> icons = [];

  if (product.isFavorite) {
    icons.add(Icon(Icons.favorite, color: Colors.pink));
    icons.add(SizedBox(width: 10));
  }

  return icons;
}

void _showSnackBar(ScaffoldState scaffold, String content) {
  scaffold.hideCurrentSnackBar();
  scaffold.showSnackBar(
    SnackBar(content: Text(content), duration: Duration(seconds: 2)),
  );
}

void _navigateToOverviewScreen(BuildContext context, Product selectedProduct) {
  Navigator.of(context)
      .pushNamed(productOverviewRoute, arguments: selectedProduct);
}
