import 'dart:math';

import 'package:flutter/foundation.dart';

import '../providers/cart.dart';
import '../models/product.dart';

class Order {
  final int _id;
  final DateTime _moment;
  final List<Product> _products;

  const Order({
    @required int id,
    @required DateTime moment,
    @required List<Product> products,
  })  : _id = id,
        _moment = moment,
        _products = products;

  int get id => _id;

  DateTime get moment => _moment;

  List<Product> get products => [..._products];

  double get totalValue {
    return _products.fold(0.0, (value, product) => value += product.price);
  }
}

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
