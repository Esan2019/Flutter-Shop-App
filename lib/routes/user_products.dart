import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../widgets/product_card/product_card.dart';
import '../widgets/product_card/product_card_gestures.dart';
import '../widgets/product_card/gesture_background.dart';
import '../widgets/no_products_warning.dart';
import '../routes_handler.dart';

class UserProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.products;
    ScaffoldState scaffold;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(
              editProduct,
              arguments: {'ancestorScaffold': scaffold},
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          scaffold = Scaffold.of(ctx);

          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<Products>(context, listen: false)
                  .fetchProductsFromDatabase()
                  .catchError((error) {
                scaffold.showSnackBar(SnackBar(
                  content: Text(
                    error,
                    textAlign: TextAlign.center,
                  ),
                ));
              });
            },
            child: !productsProvider.hasAtLeastOneProduct
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: NoProductsWarning(),
                      height: constraints.maxHeight,
                    ),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final product = products.elementAt(index);

                      return ProductCardGestures(
                        key: ValueKey<String>(product.id),
                        child: ProductCard(product),
                        onTap: () => Navigator.of(context).pushNamed(
                          productOverviewRoute,
                          arguments: product,
                        ),
                        onRightSwipe: () {
                          Navigator.of(context).pushNamed(
                            editProduct,
                            arguments: {
                              'product': product,
                              'ancestorScaffold': scaffold,
                            },
                          );
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
                                    const SizedBox(height: 8),
                                    Text(
                                      '${product.title}.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Tem certeza que deseja prosseguir? Esta ação é irreversível!',
                                    ),
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                    child: const Text('NÃO, HOUVE UM ENGANO'),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'SIM, QUERO DELETAR',
                                      style: TextStyle(
                                        color: Theme.of(context).errorColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      productsProvider
                                          .deleteProduct(product.id)
                                          .catchError(
                                        (error) {
                                          scaffold.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                error,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                      );
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
        },
      ),
    );
  }
}
