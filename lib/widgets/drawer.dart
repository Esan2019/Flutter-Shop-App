import 'package:flutter/material.dart';

import '../routes_handler.dart';

double totalAvailableHeight;
double totalAvailableWidth;

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigate(String route) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, route);
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
                  DrawerTitle(),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Roupas favoritas'),
                    onTap: () => navigate(favoritesRoute),
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text('Minha sacolinha'),
                    onTap: () => navigate(cartItemsRoute),
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Meus pedidos'),
                    onTap: () => navigate(ordersOverview),
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

class DrawerTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Menu'),
    );
  }
}
