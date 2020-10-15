import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../size_config.dart';
import '../routes_handler.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

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

Products productsProvider;
Cart cartProvider;

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    productsProvider = Provider.of<Products>(context, listen: false);
    cartProvider = Provider.of<Cart>(context, listen: false);

    return Provider<Product>.value(
      value: product,
      child: CardWithGestures(),
    );
  }
}

class CardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return Card(
      elevation: 12,
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: SizeConfig.getHeightPercentage(50),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CardBottomBar()
        ],
      ),
    );
  }
}

class CardBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return Positioned(
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
            )
          ],
        ),
        child: Column(
          children: [
            ////// TITLE LABEL //////
            Container(
              height: SizeConfig.getHeightPercentage(3.5),
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Text(product.title, style: productTitleStyle),
              ),
            ),

            ////// PRICE AND ICONS LABEL //////
            Container(
              height: SizeConfig.getHeightPercentage(3.5),
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Consumer2<Products, Cart>(
                  child: Text('R\$ ${product.price}', style: productPriceStyle),
                  builder: (_, products, cart, child) {
                    return Row(
                      children: [
                        ...getIcons(
                          isFavorite: product.isFavorite,
                          isInCart: cart.contains(product),
                        ),
                        child
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWithGestures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        if (cartProvider.contains(product)) {
          cartProvider.removeItem(product.id);
          return false;
        }
        cartProvider.addItemOrIncreaseQuantity(product);
        return false;
      },
      background: Consumer<Cart>(
        builder: (_, cart, child) {
          return DismissibleBackground(cart.contains(product));
        },
      ),
      child: GestureDetector(
        child: CardContainer(),
        onTap: () => _navigateToOverviewScreen(context, product),
        onDoubleTap: productsProvider.toggleFavoriteStatus(product),
      ),
    );
  }
}

class DismissibleBackground extends StatelessWidget {
  final bool isInCart;
  DismissibleBackground(this.isInCart);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      color: isInCart ? const Color(0xFFF2804E) : Theme.of(context).accentColor,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag,
            size: 40,
            color: isInCart ? const Color(0xFFF5C6BC) : const Color(0xFFF5BCE4),
          ),
          Text(
            isInCart ? 'Remover da sacolinha' : 'Salvar na sacolinha',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF5C6BC),
            ),
          )
        ],
      ),
    );
  }
}

List<Widget> getIcons({bool isFavorite, bool isInCart}) {
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

void _navigateToOverviewScreen(BuildContext context, Product selectedProduct) {
  Navigator.of(context)
      .pushNamed(productOverviewRoute, arguments: selectedProduct);
}
