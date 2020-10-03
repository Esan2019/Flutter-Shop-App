import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/product_card.dart';
import '../widgets/drawer.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';
import '../providers/cart.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false).products;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemsCount,
            ),
            child: FlatButton(
              child: Row(
                children: [
                  Icon(Icons.shopping_bag),
                  Text('Sacolinha'),
                ],
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        itemCount: products.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return ProductCard(products.elementAt(index));
        },
      ),
    );
  }
}
