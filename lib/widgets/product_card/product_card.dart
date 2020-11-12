import 'package:flutter/material.dart';

import '../../size_config.dart';
import '../../models/product.dart';
import '../../constants.dart';
import '../fallback_product_image.dart';

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
          FadeInImage.assetNetwork(
            width: SizeConfig.screenWidth,
            height: SizeConfig.getHeightPercentage(50),
            placeholder: fallbackImagePath,
            image: product.imageUrl,
            fit: BoxFit.cover,
            imageErrorBuilder: (ctx, error, stacktrace) {
              return FallbackProductImage(
                width: SizeConfig.screenWidth,
                height: SizeConfig.getHeightPercentage(50),
                alignment: Alignment.center,
                style: productCardTitleStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overlay: Colors.black26,
              );
            },
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
                            'R\$ ${product.price.toStringAsFixed(2).replaceAll(".", ",")}',
                            style: productCardPriceStyle,
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
