import 'package:flutter/material.dart';

import '../routes_handler.dart';

double totalAvailableHeight;
double totalAvailableWidth;

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void push(String route) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, route);
    }

    void replace(String route) {
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, route);
    }

    return SafeArea(
      child: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              DrawerTitle(),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Roupas favoritas'),
                onTap: () => push(favoritesRoute),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('Minha sacolinha'),
                onTap: () => push(cartItemsRoute),
              ),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Meus pedidos'),
                onTap: () => push(ordersOverview),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Página Inicial'),
                onTap: () => replace(homeRoute),
              ),
              ListTile(
                leading: Icon(Icons.add_business),
                title: Text('Gerenciar produtos'),
                onTap: () => replace(userProducts),
              ),
            ],
          ),
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
