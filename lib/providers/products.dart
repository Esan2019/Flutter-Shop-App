import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/product.dart';

const _productsUrl = firebaseDatabaseUrl + 'products.json';

class Products with ChangeNotifier {
  List<Product> _products;

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

  Future<void> fetchProductsFromDatabase() async {
    http.Response response;

    try {
      print(1);
      response = await http.get(_productsUrl);
    } on http.ClientException {
      throw ('Não foi possível carregar os produtos. Verifique se você possui conexão com a internet.');
    }

    final products = json.decode(response.body) as Map<String, dynamic>;

    final List<Product> fetchedProducts = [];

    products.forEach((productId, productMap) {
      productMap['id'] = productId;
      fetchedProducts.add(Product.fromMap(productMap));
    });

    _products = fetchedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    http.Response response;

    final productMap = product.toMap();

    try {
      response = await http.post(_productsUrl, body: json.encode(productMap));
    } on http.ClientException {
      throw 'Não foi possível estabelecer uma conexão com o servidor. Verifique se você possui conexão com a internet.';
    }

    if (response.statusCode != 200)
      throw 'Não foi possível adicionar o produto.';

    final productId = json.decode(response.body)['name'];
    productMap['id'] = productId;

    _products.add(Product.fromMap(productMap));
    notifyListeners();
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
