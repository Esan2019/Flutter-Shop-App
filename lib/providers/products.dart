import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: '1',
      title: 'Terno de alfaiataria verde musgo',
      description: 'Sem descrição',
      price: 29.99,
      imageUrl: 'https://i.imgur.com/94qtexK.jpg',
    ),
    Product(
      id: '2',
      title: 'Vestido branco longo com fenda e decote profundo',
      description: 'Sem descrição',
      price: 59.99,
      imageUrl: 'https://i.imgur.com/4gzMFfk.jpg',
    ),
    Product(
      id: '3',
      title: 'Camisa com amarração lateral e detalhes em escrita',
      description: 'Sem descrição',
      price: 19.99,
      imageUrl: 'https://i.imgur.com/dbJldKH.jpg',
    ),
    Product(
      id: '4',
      title: 'Blusa de mangas bufantes e botões',
      description: 'Sem descrição',
      price: 49.99,
      imageUrl: 'https://i.imgur.com/F0YgiZ1.jpg',
    ),
  ];

  bool get hasAnyFavorite => favoriteProducts.length >= 1;

  bool get hasAtLeastOneProduct => _products.length > 0;

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  void toggleFavoriteStatus(Product product) {
    _getProductByIndex(_getProductIndex(product))..toggleFavoriteStatus();
    notifyListeners();
  }

  void editProduct(Product product) {
    final productIndex = _getProductIndexById(product.id);
    deleteProduct(_getProductByIndex(productIndex));
    _products.insert(productIndex, product);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    const url = firebaseDatabaseUrl + 'products.json';
    final productMap = product.toMap();

    try {
      final response = await http.post(url, body: json.encode(productMap));

      if (response.statusCode != 200)
        throw 'Não foi possível adicionar o produto.';

      final productId = json.decode(response.body)['name'];
      productMap['id'] = productId;

      _products.add(Product.fromMap(productMap));
      notifyListeners();
      return Future.delayed(Duration(seconds: 8));
    } on http.ClientException {
      throw 'Não foi possível estabelecer uma conexão com o servidor. Verifique se você possui conexão com a internet.';
    }
  }

  void deleteProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  bool contains(Product product) {
    if (product.id == null) return false;
    final prod = _getProductById(product.id);
    if (prod == null) return false;
    return true;
  }

  Product _getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Product _getProductByIndex(int index) {
    return _products.elementAt(index);
  }

  int _getProductIndexById(String id) {
    final product = _getProductById(id);
    return _products.indexOf(product);
  }

  int _getProductIndex(Product product) {
    return _products.indexOf(product);
  }
}
