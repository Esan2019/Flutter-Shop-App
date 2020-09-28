import 'package:flutter/material.dart';

import 'routes_handler.dart';

void main() => runApp(ShopApp());

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      onGenerateRoute: RoutesHandler.handleRoute,
      initialRoute: homeRoute,
    );
  }
}