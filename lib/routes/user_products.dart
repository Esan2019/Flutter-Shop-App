import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../widgets/product_card/product_card.dart';
import '../widgets/product_card/product_card_gestures.dart';
import '../widgets/product_card/gesture_background.dart';
import '../routes_handler.dart';

class UserProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(editProduct),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          final product = products.elementAt(index);

          return ProductCardGestures(
            key: ValueKey<String>(product.id),
            child: ProductCard(product),
            onTap: () {},
            onRightSwipe: () {
              Navigator.of(context).pushNamed(editProduct, arguments: product);
            },
            rightSwipeBackground: const GestureBackground(
              icon: Icons.edit,
              label: 'Editar item',
              color: const Color(0xFF000000),
              backgroundColor: const Color(0xFFF2804E),
              alignment: Alignment.centerLeft,
            ),
            onLeftSwipe: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Confirmar deleção'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Você está a um passo de deletar o seguinte produto:',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text('${product.title}.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(height: 8),
                        const Text(
                            'Tem certeza que deseja prosseguir? Esta ação é irreversível!'),
                      ],
                    ),
                    actions: [
                      FlatButton(
                        child: const Text('NÃO, HOUVE UM ENGANO'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      FlatButton(
                        child: Text('SIM, QUERO DELETAR',
                            style:
                                TextStyle(color: Theme.of(context).errorColor)),
                        onPressed: () {
                          productsProvider.deleteProduct(product);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            leftSwipeBackground: const GestureBackground(
              icon: Icons.delete,
              label: 'Deletar item',
              color: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFFF0000),
              alignment: Alignment.centerRight,
            ),
          );
        },
      ),
    );
  }
}
