import 'package:flutter/material.dart';

import '../../size_config.dart';
import '../../models/product.dart';
import '../../constants.dart';

const productPriceStyle = TextStyle(
  color: const Color(0xFFFFFFFF),
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: const Color(0xFF000000),
      blurRadius: 8,
    ),
  ],
);

class ProductCard extends StatelessWidget {
  final Product product;
  final List<Widget> icons;
  ProductCard(this.product, {this.icons});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: SizeConfig.getHeightPercentage(50),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFf5d9ff).withOpacity(0.65),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.getHeightPercentage(3.5),
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        product.title,
                        style: productCardTitleStyle,
                      ),
                    ),
                  ),
                  Container(
                    height: SizeConfig.getHeightPercentage(3.5),
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Row(
                        children: [
                          ...?icons,
                          Text(
                            'R\$ ${product.price}',
                            style: productPriceStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
