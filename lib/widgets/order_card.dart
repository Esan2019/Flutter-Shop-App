import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../size_config.dart';
import '../models/order.dart';

class ExpandableOrderCard extends StatelessWidget {
  final Order order;
  ExpandableOrderCard(this.order);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.all(18),
      key: ValueKey(order.id),
      title: Text(
        DateFormat('dd/MM/yyyy - HH:mm').format(order.moment),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${order.totalItemsQuantity} itens, totalizando R\$${order.totalValue.toStringAsFixed(2)}',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      children: order.items.map((cartItem) {
        return ListTile(
          onLongPress: null,
          title: Text(
            cartItem.product.title,
            style: TextStyle(fontSize: 14 * SizeConfig.textScaleFactor),
          ),
          leading: Text('${cartItem.quantity}x'),
          trailing: Text('R\$${cartItem.product.price.toStringAsFixed(2)}'),
        );
      }).toList(),
    );
  }
}
