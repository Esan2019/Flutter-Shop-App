import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Order {
  final String _id;
  final DateTime _moment;
  final List<CartItem> _items;

  const Order({
    @required String id,
    @required DateTime moment,
    @required List<CartItem> items,
  })  : _id = id,
        _moment = moment,
        _items = items;

  static Order fromMap(Map<String, dynamic> map) {
    final id = map['id'] as String;
    final moment = DateTime.parse(map['moment']);
    final items = map['items'] as List<dynamic>;

    final List<CartItem> cartItems = [];

    items.forEach((item) => cartItems.add(CartItem.fromMap(item)));

    return Order(id: id, moment: moment, items: cartItems);
  }

  String get id => _id;

  int get totalItemsQuantity => _items.fold(
        0,
        (value, cartItem) => value += cartItem.quantity,
      );

  DateTime get moment => _moment;

  List<CartItem> get items => _items;

  double get totalValue {
    return _items.fold(0.0, (value, cartItem) => value += cartItem.totalValue);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moment': moment.toIso8601String(),
      'totalItemsQuantity': totalItemsQuantity,
      'totalValue': totalValue,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}
