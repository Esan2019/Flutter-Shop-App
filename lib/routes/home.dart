import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/product_card.dart';
import '../widgets/drawer.dart';
import '../providers/products.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false).products;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          FlatButton(
            child: Row(
              children: [Icon(Icons.shopping_bag), Text('Sacolinha')],
            ),
            onPressed: () {},
          )
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
