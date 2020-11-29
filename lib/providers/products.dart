import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/product.dart';
import './auth.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String _productsUrl, _favoritesUrl;
  final Auth _authProvider;

  Products(this._authProvider)
      : _productsUrl =
            firebaseDatabaseUrl + 'products.json?auth=${_authProvider.token}',
        _favoritesUrl =
            '${firebaseDatabaseUrl}userFavorites/${_authProvider.userId}';

  bool get hasAnyFavorite => favoriteProducts.length >= 1;

  bool get hasAtLeastOneProduct => _products.length > 0;

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  Future<void> toggleFavoriteStatus(Product product) async {
    final url = '$_favoritesUrl/${product.id}.json?auth=${_authProvider.token}';

    // Make changes locally first for better performance
    product.toggleFavoriteStatus();
    notifyListeners();

    try {
      await http.put(
        url,
        body: json.encode(product.isFavorite),
      );
    } catch (e) {
      // Fallback in case of errors
      product.toggleFavoriteStatus();
      notifyListeners();

      throw 'Não foi possível alterar o status de favorito.\nVerifique se você possui conexão com a internet.';
    }
  }

  Future<void> editProduct(Product product) async {
    final url =
        '${firebaseDatabaseUrl}products/${product.id}.json?auth=${_authProvider.token}';

    final productMap = product.toMap();

    final encodedProduct = json.encode(productMap);

    // For fallback in case of errors
    final oldProduct = _getProductById(product.id);

    // Make changes locally first for better performance
    _replaceProduct(oldProduct, product);

    try {
      await http.patch(url, body: encodedProduct);
    } catch (error) {
      // Fallback in case of errors
      _replaceProduct(product, oldProduct);

      throw 'Não foi possível editar o produto.\nVerifique se você possui conexão com a internet.';
    }
  }

  Future<void> fetchProductsFromDatabase() async {
    http.Response response;

    try {
      final favoritesUrl =
          '${firebaseDatabaseUrl}userFavorites/${_authProvider.userId}.json';

      if (_authProvider.isAuth) {
        response = await http.get(_productsUrl);
      } else {
        response = await http.get(firebaseDatabaseUrl + 'products.json');
      }

      final products = json.decode(response.body) as Map<String, dynamic>;

      final favoritesResponse = await http.get(favoritesUrl);
      final favorites = json.decode(favoritesResponse.body);

      final List<Product> fetchedProducts = [];

      if (products != null) {
        products.forEach((productId, productMap) {
          productMap['id'] = productId;

          if (favorites != null) {
            productMap['isFavorite'] = favorites[productId] ?? false;
          } else {
            productMap['isFavorite'] = false;
          }

          fetchedProducts.add(Product.fromMap(productMap));
        });
      }

      _products = fetchedProducts;

      notifyListeners();
    } catch (error) {
      throw ('Não foi possível carregar os produtos.\nVerifique se você possui conexão com a internet.');
    }
  }

  Future<void> addProduct(Product product) async {
    http.Response response;

    final productMap = product.toMap();

    try {
      response = await http.post(_productsUrl, body: json.encode(productMap));
    } catch (error) {
      throw 'Não foi possível estabelecer uma conexão com o servidor.\nVerifique se você possui conexão com a internet.';
    }

    if (response.statusCode != 200)
      throw 'Não foi possível adicionar o produto.';

    final productId = json.decode(response.body)['name'];
    productMap['id'] = productId;

    _products.add(Product.fromMap(productMap));
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        '${firebaseDatabaseUrl}products/$id.json?auth=${_authProvider.token}';

    // For fallback in case of errors
    final existingProductIndex = _getProductIndexById(id);
    final existingProduct = _getProductById(id);

    // Make changes locally first for better performance
    _deleteProduct(id);

    try {
      await http.delete(url);
    } catch (error) {
      // Fallback in case of errors
      _insertProductAtIndex(existingProduct, existingProductIndex);

      throw 'Não foi possível deletar o produto.\nVerifique se você possui conexão com a internet.';
    }
  }

  bool contains(Product product) {
    if (product.id == null) return false;

    final prod = _getProductById(product.id);

    if (prod == null) return false;

    return true;
  }

  void _deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);

    notifyListeners();
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

  void _insertProductAtIndex(Product product, int index) {
    _products.insert(index, product);

    notifyListeners();
  }
}
