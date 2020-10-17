import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../size_config.dart';
import '../providers/orders.dart';
import '../widgets/order_card.dart';

class OrdersOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final orders = Provider.of<Orders>(context, listen: false).orders;

    return Scaffold(
      body: ListView.builder(
        itemCount: orders.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) => ExpandableOrderCard(orders.elementAt(index)),
      ),
    );
  }
}
