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
    _getProductById(product.id).toggleFavoriteStatus();

    notifyListeners();
  }

  Future<void> editProduct(Product product) async {
    final url = '${firebaseDatabaseUrl}products/${product.id}.json';

    final productMap = product.toMap()..remove('id')..remove('isFavorite');

    final encodedProduct = json.encode(productMap);

    // For fallback in case of errors
    final oldProduct = _getProductById(product.id);

    // Make changes locally first for better performance
    _replaceProduct(oldProduct, product);

    try {
      var response = await http.patch(url, body: encodedProduct);

      if (response.statusCode != 200) {
        _replaceProduct(product, oldProduct);
        throw 'Não foi possível editar o produto. Verifique se este produto não foi deletado antes de você salvar suas alterações';
      }
    } on http.ClientException {
      _replaceProduct(product, oldProduct);
      throw 'Não foi possível editar o produto. Verifique se você possui conexão com a internet';
    }
  }

  Future<void> fetchProductsFromDatabase() async {
    http.Response response;

    try {
      response = await http.get(_productsUrl);
    } on http.ClientException {
      throw ('Não foi possível carregar os produtos. Verifique se você possui conexão com a internet.');
    }

    final products = json.decode(response.body) as Map<String, dynamic>;

    final List<Product> fetchedProducts = [];

    if (products != null) {
      products.forEach((productId, productMap) {
        productMap['id'] = productId;

        fetchedProducts.add(Product.fromMap(productMap));
      });
    }

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

  Future<void> deleteProduct(String id) async {
    final url = '${firebaseDatabaseUrl}products/$id.json';

    // For fallback in case of errors
    final existingProductIndex = _getProductIndexById(id);
    final existingProduct = _getProductById(id);

    // Make changes locally first for better performance
    _deleteProduct(id);

    try {
      await http.delete(url);
    } on http.ClientException {
      _insertProductAtIndex(existingProduct, existingProductIndex);
      throw 'Não foi possível deletar o produto. Verifique se você possui conexão com a internet.';
    }
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

  int _getProductIndexById(String id) {
    return _products.indexWhere((product) => product.id == id);
  }

  void _replaceProduct(Product oldProduct, Product newProduct) {
    final oldProductIndex = _getProductIndexById(oldProduct.id);

    _products[oldProductIndex] = newProduct;

    notifyListeners();
  }

  void _deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);

    notifyListeners();
  }

  void _insertProductAtIndex(Product product, int index) {
    _products.insert(index, product);

    notifyListeners();
  }
}
