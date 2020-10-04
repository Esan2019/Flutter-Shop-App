import 'package:flutter/foundation.dart';

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