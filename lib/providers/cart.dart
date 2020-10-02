import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  final Product _product;
  int _quantity;
  CartItem(this._product) : this._quantity = 1;

  double get totalValue => _product.price * _quantity;

  double get productPrice => _product.price;

  int get id => _product.id;

  void increaseQuantity() => _quantity++;

  void decreaseQuantity() {
    if (_quantity > 1) _quantity--;
  }
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get totalValue {
    return _items.fold(
      0.0,
      (value, cartItem) => value += cartItem.totalValue,
    );
  }

  void addItemOrIncreaseQuantity(Product product) {
    var cartItem = _items.firstWhere((ca) => ca.id == product.id) ?? null;
    if (cartItem != null) {
      cartItem.increaseQuantity();
      notifyListeners();
    } else {
      _items.add(CartItem(product));
      notifyListeners();
    }
  }

  void decreaseQuantity(CartItem cartItem) {
    _items.firstWhere((ca) => ca.id == cartItem.id)..decreaseQuantity();
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}
