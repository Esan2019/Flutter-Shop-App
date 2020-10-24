import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../size_config.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

const whitishColor = const Color(0xFFebebeb);

class ProductOverview extends StatelessWidget {
  final Product product;
  ProductOverview(this.product);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final productsProvider = Provider.of<Products>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ////// PRODUCT IMAGE //////
            Container(
              height: SizeConfig.getHeightPercentage(68),
              width: SizeConfig.screenWidth,
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.getHeightPercentage(64),
                    width: SizeConfig.screenWidth,
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                  ),
                  FavoriteButton(
                    () => productsProvider.toggleFavoriteStatus(product),
                    product.isFavorite,
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getHeightPercentage(0.5)),

            ////// PRODUCT TITLE //////
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              // 0.755
              height: SizeConfig.getHeightPercentage(7),
              child: FittedBox(
                child: Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Spacer(),

            AddToCartButton(product),
            SizedBox(height: SizeConfig.getHeightPercentage(1))
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final Function onPressed;
  final bool isFavorite;
  FavoriteButton(this.onPressed, this.isFavorite);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(color: const Color(0xFF404040), blurRadius: 6),
          ],
        ),
        height: SizeConfig.getHeightPercentage(8),
        width: SizeConfig.getHeightPercentage(8),
        child: IconButton(
          color: whitishColor,
          splashRadius: 0.01,
          onPressed: () => setState(widget.onPressed),
          icon: Icon(
            Icons.favorite,
            color: widget.isFavorite ? Colors.pinkAccent : whitishColor,
          ),
        ),
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final Product product;
  const AddToCartButton(this.product);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    final isInCart = cartProvider.contains(product);

    return GestureDetector(
      onTap: () {
        if (isInCart) {
          cartProvider.removeItem(product);
        } else {
          cartProvider.addItem(product);
        }
      },
      child: Container(
        height: SizeConfig.getHeightPercentage(8),
        width: SizeConfig.getWidthPercentage(90),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isInCart
              ? const Color(0xFFF2804E)
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF505050), blurRadius: 6),
          ],
        ),
        child: Row(
          mainAxisAlignment: isInCart
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: isInCart ? const Color(0xFFF5C6BC) : whitishColor,
                ),
                Text(
                  isInCart ? 'Remover da sacolinha' : 'Salvar na sacolinha',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isInCart ? const Color(0xFFF5C6BC) : whitishColor,
                  ),
                ),
              ],
            ),
            isInCart
                ? Container()
                : Text(
                    '(R\$${product.price.toStringAsFixed(2)})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: whitishColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
