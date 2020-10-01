import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';
import '../routes_handler.dart';
import '../providers/products.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: Builder(
        builder: (builderContext) {
          final currentScaffoldState = Scaffold.of(builderContext);
          return ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(products[index].id),
                // TODO: implement confirmDismiss function
                confirmDismiss: (_) async {
                  _showSnackBar(currentScaffoldState,
                      'Salvo na sacolinha: ${products[index].title}');
                  return false;
                },
                direction: DismissDirection.startToEnd,
                background: Container(
                  padding: const EdgeInsets.only(left: 10),
                  color: Theme.of(context).accentColor,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_bag, size: 40),
                      Text('Salvar na sacolinha',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                child: GestureDetector(
                  child: ChangeNotifierProvider.value(
                      child: ProductCard(), value: products[index]),
                  onTap: () {
                    _navigateToOverviewScreen(context, products[index]);
                  },
                  // TODO: implement onDoubleTap function
                  onDoubleTap: () {
                    products[index].toggleFavoriteStatus();
                    _showSnackBar(currentScaffoldState,
                        'Item curtido: ${products[index].title}');
                  },
                ),
              );
            },
            itemCount: products.length,
            physics: const BouncingScrollPhysics(),
          );
        },
      ),
    );
  }

  void _showSnackBar(ScaffoldState scaffold, String content) {
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(content: Text(content), duration: Duration(seconds: 2)),
    );
  }

  void _navigateToOverviewScreen(
      BuildContext context, Product selectedProduct) {
    Navigator.of(context)
        .pushNamed(productOverviewRoute, arguments: selectedProduct);
  }
}
