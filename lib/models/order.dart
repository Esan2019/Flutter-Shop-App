import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Order {
  final int _id;
  final DateTime _moment;
  final List<CartItem> _items;

  const Order({
    @required int id,
    @required DateTime moment,
    @required List<CartItem> items,
  })  : _id = id,
        _moment = moment,
        _items = items;

  int get id => _id;

  int get totalItemsQuantity => _items.fold(
        0,
        (value, cartItem) => value += cartItem.quantity,
      );

  DateTime get moment => _moment;

  List<CartItem> get items => _items;

  double get totalValue {
    return _items.fold(0.0, (value, cartItem) => value += cartItem.totalValue);
  }
}
