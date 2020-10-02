import 'package:flutter/material.dart';

import '../routes_handler.dart';

double totalAvailableHeight;
double totalAvailableWidth;

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigate(String route) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, favoritesRoute);
    }

    return SafeArea(
      child: Drawer(
        child: LayoutBuilder(
          builder: (_, constraints) {
            totalAvailableHeight = constraints.maxHeight;
            totalAvailableWidth = constraints.maxWidth;

            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  ShopBrand(),
                  ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text('Cart'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Favorites'),
                    onTap: () => navigate(favoritesRoute),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShopBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Image.network(
        'https://i.imgur.com/vHluDFO.png',
        fit: BoxFit.cover,
        width: totalAvailableWidth,
      ),
    );
  }
}
