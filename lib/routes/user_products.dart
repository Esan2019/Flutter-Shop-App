import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../widgets/product_card/product_card.dart';

class UserProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar produtos'),
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) => ProductCard(products.elementAt(index)),
      ),
    );
  }
}
