import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void createOrder(List<CartItem> cartItems) {
    _orders.insert(
      0,
      Order(
        id: Random().nextInt(2000).toString(),
        moment: DateTime.now(),
        items: cartItems,
      ),
    );

    notifyListeners();
  }
}
