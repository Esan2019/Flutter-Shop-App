import 'package:flutter/material.dart';
import 'package:shop/widgets/product_card.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          itemBuilder: (context, index) => ProductCard(dummyProducts[index]),
          itemCount: dummyProducts.length,
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
