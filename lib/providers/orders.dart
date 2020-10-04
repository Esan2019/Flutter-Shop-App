import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../models/product.dart';
import '../providers/cart.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void createOrder(List<CartItem> cartItems) {
    List<Product> products = [];

    cartItems.forEach((cartItem) => products.add(cartItem.product));

    _orders.insert(
      0,
      Order(
        id: Random().nextDouble().toInt(),
        moment: DateTime.now(),
        products: products,
      ),
    );

    notifyListeners();
  }
}
