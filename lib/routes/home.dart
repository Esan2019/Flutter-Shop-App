import 'package:flutter/material.dart';

import 'package:shop/widgets/product_card.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';
import '../routes_handler.dart';

class Home extends StatelessWidget {
  final dummyProducts = [
    Product(
      id: 1,
      title: 'Terno de alfaiataria verde musgo',
      description: 'Sem descrição',
      price: 29.99,
      imageUrl: 'https://i.imgur.com/94qtexK.jpg',
    ),
    Product(
      id: 2,
      title: 'Vestido branco longo com fenda e decote profundo',
      description: 'Sem descrição',
      price: 59.99,
      imageUrl: 'https://i.imgur.com/4gzMFfk.jpg',
    ),
    Product(
      id: 3,
      title: 'Camisa com amarração lateral e detalhes em escrita',
      description: 'Sem descrição',
      price: 19.99,
      imageUrl: 'https://i.imgur.com/dbJldKH.jpg',
    ),
    Product(
      id: 4,
      title: 'Blusa de mangas bufantes e botões',
      description: 'Sem descrição',
      price: 49.99,
      imageUrl: 'https://i.imgur.com/F0YgiZ1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                key: ValueKey(dummyProducts[index].id),
                // TODO: implement confirmDismiss function
                confirmDismiss: (_) async {
                  _showSnackBar(
                    currentScaffoldState,
                    'Salvo na sacolinha: ${dummyProducts[index].title}',
                  );
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
                      Text(
                        'Salvar na sacolinha',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                child: GestureDetector(
                  child: ProductCard(dummyProducts[index]),
                  onTap: () => _navigateToOverviewScreen(
                    context,
                    dummyProducts[index],
                  ),
                  // TODO: implement onDoubleTap function
                  onDoubleTap: () {
                    _showSnackBar(currentScaffoldState,
                        'Item curtido: ${dummyProducts[index].title}');
                  },
                ),
              );
            },
            itemCount: dummyProducts.length,
            physics: const BouncingScrollPhysics(),
          );
        },
      ),
    );
  }

  void _showSnackBar(ScaffoldState scaffold, String content) {
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToOverviewScreen(
      BuildContext context, Product selectedProduct) {
    Navigator.of(context)
        .pushNamed(productOverviewRoute, arguments: selectedProduct);
  }
}
