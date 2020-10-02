import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/product_card.dart';

double totalScreenHeight;

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    totalScreenHeight = mediaQuery.size.height - mediaQuery.padding.top;

    var favoriteProducts = Provider.of<Products>(context).favoriteProducts;
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
  FavoritesList(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ChangeNotifierProvider.value(
          value: products.elementAt(index),
          child: ProductCard(),
        );
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
              'Você ainda não adicionou nenhuma roupa como favorita',
              textAlign: TextAlign.center,
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
