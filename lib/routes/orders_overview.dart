import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../size_config.dart';
import '../providers/orders.dart';
import '../widgets/order_card.dart';

class OrdersOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final ordersProvider = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: ordersProvider.fetchOrdersFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error == null) {
              return ListView.builder(
                itemCount: ordersProvider.orders.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, index) =>
                    ExpandableOrderCard(ordersProvider.orders.elementAt(index)),
              );
            } else {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ));
            }
          } else {
            return Center(
                child: Lottie.asset('assets/animations/bouncy-balls.json'));
          }
        },
      ),
    );
  }
}
