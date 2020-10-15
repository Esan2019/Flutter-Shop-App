import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../size_config.dart';
import '../providers/products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final productsProvider = Provider.of<Products>(context);

    return Scaffold(
      body: productsProvider.hasAnyFavorite
          ? FavoritesList(productsProvider.favoriteProducts)
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
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ProductCard(
          products.elementAt(index),
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
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
              'Quando você marcar uma roupa como favorita, ela irá aparecer aqui!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
