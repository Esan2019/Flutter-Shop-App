import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../widgets/product_card/product_card.dart';
import '../widgets/product_card/product_card_gestures.dart';
import '../widgets/product_card/gesture_background.dart';

class UserProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            // TODO: implement onPressed function
            onPressed: () {},
          )
        ],
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) => ProductCardGestures(
          key: ValueKey<int>(products.elementAt(index).id),
          child: ProductCard(products.elementAt(index)),
          onTap: () {},
          // TODO: implement onRightSwipe function
          onRightSwipe: () {},
          rightSwipeBackground: const GestureBackground(
            icon: Icons.edit,
            label: 'Editar item',
            color: const Color(0xFF000000),
            backgroundColor: const Color(0xFFF2804E),
            alignment: Alignment.centerLeft,
          ),
          // TODO: implement onLeftSwipe function
          onLeftSwipe: () {},
          leftSwipeBackground: const GestureBackground(
            icon: Icons.delete,
            label: 'Deletar item',
            color: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFFFF0000),
            alignment: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}
