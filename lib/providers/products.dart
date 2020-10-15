import 'package:flutter/material.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 1,
      title: 'Terno de alfaiataria verde musgo',
      description: 'Sem descrição',
      price: 29.99,
      imageUrl: 'https://i.imgur.com/94qtexK.jpg',
    ),
    Product(
      id: 2,
      title: 'Vestido branco longo com fenda e decote profundo',
      description: 'Sem descrição',
      price: 59.99,
      imageUrl: 'https://i.imgur.com/4gzMFfk.jpg',
    ),
    Product(
      id: 3,
      title: 'Camisa com amarração lateral e detalhes em escrita',
      description: 'Sem descrição',
      price: 19.99,
      imageUrl: 'https://i.imgur.com/dbJldKH.jpg',
    ),
    Product(
      id: 4,
      title: 'Blusa de mangas bufantes e botões',
      description: 'Sem descrição',
      price: 49.99,
      imageUrl: 'https://i.imgur.com/F0YgiZ1.jpg',
    ),
  ];

  bool get hasAnyFavorite => favoriteProducts.length >= 1;

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  Function toggleFavoriteStatus(Product product) {
    return () {
      _products.elementAt(_products.indexOf(product))..toggleFavoriteStatus();
      notifyListeners();
    };
  }
}
