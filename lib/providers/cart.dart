import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get totalValue {
    return _items.fold(
      0.0,
      (value, cartItem) => value += cartItem.totalValue,
    );
  }

  int get distinctItemsCount => _items.length;

  int get totalItemsCount =>
      _items.fold(0, (count, cartItem) => count += cartItem.quantity);

  bool contains(Product product) {
    return _getCartItemIndex(product).isNegative ? false : true;
  }

  bool get isEmpty => _items.isEmpty;

  void addItem(Product product) {
    if (!contains(product)) _items.add(CartItem(product));
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((cartItem) => cartItem.id == product.id);
    notifyListeners();
  }

  void increaseQuantity(CartItem cartItem) {
    cartItem.increaseQuantity();
    notifyListeners();
  }

  void decreaseQuantity(CartItem cartItem) {
    cartItem.decreaseQuantity();
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }

  int _getCartItemIndex(Product product) {
    return _items.indexWhere((cartItem) => cartItem.id == product.id);
  }
}
