import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/product_card.dart';

double totalScreenHeight;
Products productsProvider;

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    totalScreenHeight = mediaQuery.size.height - mediaQuery.padding.top;

    productsProvider = Provider.of<Products>(context);
    final favoriteProducts = productsProvider.favoriteProducts;

    final bool hasAnyFavorite = favoriteProducts.length >= 1;

    return Scaffold(
      body: hasAnyFavorite
          ? FavoritesList(favoriteProducts)
          : NoFavoritesWarning(),
    );
  }
}

class FavoritesList extends StatelessWidget {
  final List<Product> products;
  const FavoritesList(this.products);

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context).favoriteProducts;
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ProductCard(products.elementAt(index));
      },
    );
  }
}

class NoFavoritesWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/no-favorites.json', height: 80),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Quando você marcar uma roupa como favorita, ela irá aparecer aqui!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
