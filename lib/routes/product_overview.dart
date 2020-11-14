import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../size_config.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/fallback_product_image.dart';
import '../constants.dart';

Product globalProduct;

class ProductOverview extends StatelessWidget {
  final Product product;
  ProductOverview(this.product);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    globalProduct = product;
    final labelStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black.withOpacity(0.65),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              product.imageUrl,
              height: SizeConfig.getHeightPercentage(83),
              width: SizeConfig.screenWidth,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return FallbackProductImage(
                  height: SizeConfig.getHeightPercentage(83),
                  width: SizeConfig.screenWidth,
                  overlay: Colors.black54,
                  alignment: Alignment.center,
                  style: productCardPriceStyle,
                );
              },
            ),
            Container(
              height: SizeConfig.getHeightPercentage(100),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(height: SizeConfig.getHeightPercentage(80)),
                      Container(
                        height: SizeConfig.getHeightPercentage(70),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(color: Colors.black54, blurRadius: 6),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.title,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: productCardPriceStyle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<Cart>(
                                  builder: (ctx, cart, child) {
                                    final isInCart = cart.contains(product);

                                    return _ActionButton(
                                      isColored: isInCart,
                                      icon: Icons.shopping_bag,
                                      color: Colors.green,
                                      onTap: isInCart
                                          ? cart.removeProduct
                                          : cart.addProduct,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  'R\$${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: labelStyle,
                                ),
                                Consumer<Products>(
                                  builder: (ctx, products, child) {
                                    return _ActionButton(
                                      isColored: product.isFavorite,
                                      icon: Icons.favorite,
                                      color: Colors.pinkAccent,
                                      iconLeftPositioned: true,
                                      onTap: products.toggleFavoriteStatus,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Text(
                              'Mais informações',
                              style: labelStyle.copyWith(color: Colors.black45),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              height: SizeConfig.getHeightPercentage(35),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  product.description,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isColored;
  final bool iconLeftPositioned;
  final IconData icon;
  final BorderRadius borderRadius;
  final Color color;
  final void Function(Product) onTap;

  const _ActionButton({
    @required this.isColored,
    @required this.icon,
    @required this.borderRadius,
    @required this.color,
    @required this.onTap,
    this.iconLeftPositioned = false,
  })  : assert(isColored != null),
        assert(icon != null),
        assert(borderRadius != null),
        assert(color != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      color: isColored ? color : Colors.grey,
    );

    return GestureDetector(
      onTap: () => onTap(globalProduct),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          color: isColored
              ? color.withOpacity(0.4)
              : Colors.white.withOpacity(0.7),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (iconLeftPositioned) iconWidget,
            if (isColored) Icon(Icons.remove_circle),
            if (!isColored) Icon(Icons.add_circle, color: Colors.grey),
            if (!iconLeftPositioned) iconWidget,
          ],
        ),
      ),
    );
  }
}
