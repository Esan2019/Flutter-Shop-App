import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  final Product _product;
  int _quantity;
  CartItem(this._product) : this._quantity = 1;

  double get totalValue => _product.price * _quantity;

  double get productPrice => _product.price;

  String get productTitle => _product.title;

  String get productImageUrl => _product.imageUrl;

  int get id => _product.id;

  int get quantity => _quantity;

  void increaseQuantity() => _quantity++;

  void decreaseQuantity() {
    if (_quantity > 1) _quantity--;
  }
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  bool get isEmpty {
    return _items.isEmpty;
  }

  double get totalValue {
    return _items.fold(
      0.0,
      (value, cartItem) => value += cartItem.totalValue,
    );
  }

  int get itemsCount => _items.length;

  int get singleItemsCount =>
      _items.fold(0, (count, cartItem) => count += cartItem._quantity);

  int _getCartItemIndex(Product product) {
    return _items.indexWhere((cartItem) => cartItem.id == product.id);
  }

  bool contains(Product product) {
    return _getCartItemIndex(product).isNegative ? false : true;
  }

  void addItemOrIncreaseQuantity(Product product) {
    final cartItemIndex = _getCartItemIndex(product);

    if (cartItemIndex.isNegative) {
      _items.add(CartItem(product));
      notifyListeners();
      return;
    }

    _items.elementAt(cartItemIndex)..increaseQuantity();
    notifyListeners();
  }

  void decreaseQuantity(CartItem cartItem) {
    _items.firstWhere((ca) => ca.id == cartItem.id)..decreaseQuantity();
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((cartItem) => cartItem.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}
