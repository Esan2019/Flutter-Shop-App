import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

import '../models/product.dart';

double totalScreenHeight;
double totalScreenWidth;
const whitishColor = const Color(0xFFebebeb);

class ProductOverview extends StatelessWidget {
  final Product product;
  ProductOverview(this.product);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    totalScreenHeight = mediaQuery.size.height;
    totalScreenWidth = mediaQuery.size.width;
    final productsProvider = Provider.of<Products>(context);

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
                  FavoriteButton(
                    productsProvider.toggleFavoriteStatus(product),
                    product.isFavorite
                  ),
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
                child: Text(product.title,
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
            ),
            Spacer(),

            AddToCartButton(product.price),
            SizedBox(height: totalScreenHeight * 0.01)
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
              BoxShadow(color: const Color(0xFF404040), blurRadius: 6)
            ]),
        height: totalScreenHeight * 0.08,
        width: totalScreenHeight * 0.08,
        child: IconButton(
          color: whitishColor,
          splashRadius: 0.01,
          onPressed: () {
            setState(() {
              widget.onPressed();
            });
          },
          icon: Icon(Icons.favorite,
              color: widget.isFavorite ? Colors.pinkAccent : whitishColor),
        ),
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final double price;
  AddToCartButton(this.price);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: implement onTap function
      onTap: () {},
      child: Container(
        height: totalScreenHeight * 0.08,
        width: totalScreenWidth * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: const Color(0xFF505050), blurRadius: 6)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(Icons.shopping_bag, color: whitishColor),
              Text(
                'Salvar na sacolinha',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: whitishColor),
              ),
            ]),
            Text(
              '(R\$ $price)',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: whitishColor),
            )
          ],
        ),
      ),
    );
  }
}
