import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../size_config.dart';
import '../widgets/product_card/product_card.dart';
import '../widgets/product_card/product_card_gestures.dart';
import '../widgets/product_card/gesture_background.dart';
import '../widgets/drawer.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../routes_handler.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final products = Provider.of<Products>(context, listen: false).products;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemsCount,
            ),
            child: FlatButton(
              child: Row(
                children: [
                  Icon(Icons.shopping_bag),
                  Text('Sacolinha'),
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, cartItemsRoute),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        itemCount: products.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          final product = products.elementAt(index);

          return Consumer2<Products, Cart>(
            builder: (ctx, products, cart, child) {
              final isInCart = cart.contains(product);
              final isFavorite = product.isFavorite;
              final removeItem = cart.removeItem;
              final addItem = cart.addItemOrIncreaseQuantity;

              return ProductCardGestures(
                key: ValueKey<int>(product.id),
                child: ProductCard(
                  product,
                  icons: _getIcons(
                    isFavorite: isFavorite,
                    isInCart: isInCart,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  productOverviewRoute,
                  arguments: product,
                ),
                onRightSwipe: () {
                  if (isInCart) {
                    removeItem(product.id);
                    _showSnackbar(
                      ctx,
                      label: 'Removido da sacolinha!',
                      onPressed: () => addItem(product),
                    );
                  } else {
                    addItem(product);
                    _showSnackbar(
                      ctx,
                      label: 'Salvo na sacolinha!',
                      onPressed: () => removeItem(product.id),
                    );
                  }
                },
                rightSwipeBackground: isInCart
                    ? GestureBackground(
                        icon: Icons.shopping_bag,
                        label: 'Remover da sacolinha',
                        color: const Color(0xFFF5C6BC),
                        backgroundColor: const Color(0xFFF2804E),
                        alignment: Alignment.centerLeft)
                    : GestureBackground(
                        icon: Icons.shopping_bag,
                        label: 'Salvar na sacolinha',
                        color: const Color(0xFFF5BCE4),
                        backgroundColor: Theme.of(context).accentColor,
                        alignment: Alignment.centerLeft),
                onDoubleTap: () => products.toggleFavoriteStatus(product),
              );
            },
          );
        },
      ),
    );
  }
}

void _showSnackbar(BuildContext context,
    {@required String label, @required VoidCallback onPressed}) {
  final scaffold = Scaffold.of(context);
  scaffold.hideCurrentSnackBar();
  scaffold.showSnackBar(
    SnackBar(
      content: Text(label),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'DESFAZER',
        onPressed: onPressed,
        textColor: Theme.of(context).primaryColor,
      ),
    ),
  );
}

List<Widget> _getIcons({bool isFavorite, bool isInCart}) {
  final List<Widget> icons = [];

  if (isInCart) {
    icons.add(Icon(Icons.shopping_bag, color: const Color(0xFFF56713)));
    icons.add(SizedBox(width: 10));
  }

  if (isFavorite) {
    icons.add(Icon(Icons.favorite, color: Colors.pink));
    icons.add(SizedBox(width: 10));
  }

  return icons;
}
