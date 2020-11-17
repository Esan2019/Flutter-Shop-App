import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/cart_item.dart';
import '../constants.dart';

const _ordersUrl = firebaseDatabaseUrl + 'orders.json';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> fetchOrdersFromDatabase() async {
    try {
      final response = await http.get(_ordersUrl);
      final ordersMap = json.decode(response.body) as Map<String, dynamic>;

      if (ordersMap == null) throw 'Você ainda não fez nenhum pedido';

      final List<Order> orders = [];

      ordersMap.forEach(
        (id, orderMap) => orders.insert(
          0,
          Order.fromMap(orderMap),
        ),
      );

      _orders = orders;
    } catch (error) {
      if (error.runtimeType == String) throw error;
      throw 'Não foi possível carregar os pedidos. Verifique se você possui conexão com a internet.';
    }
  }

  Future<void> createOrder(List<CartItem> cartItems) async {
    final moment = DateTime.now();

    var order = Order(id: null, moment: moment, items: cartItems);
    final orderMap = order.toMap()..remove('id');

    try {
      final response = await http.post(_ordersUrl, body: json.encode(orderMap));
      final decodedResponse = json.decode(response.body);

      orderMap.putIfAbsent('id', () => decodedResponse['name']);

      _orders.insert(0, Order.fromMap(orderMap));

      notifyListeners();
    } catch (error) {
      throw 'Não foi possível criar o pedido. Verifique se você possui conexão com a internet.';
    }
  }
}
