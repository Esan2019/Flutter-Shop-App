import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes_handler.dart';
import './providers/products.dart';

void main() => runApp(ShopApp());

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: ThemeData(
            primaryColor: const Color(0xFFeebdff),
            accentColor: const Color(0xFF9d45ba),
            appBarTheme: AppBarTheme(color: const Color(0xFFeebdff)),
            scaffoldBackgroundColor: const Color(0xFFf5d9ff),
            fontFamily: 'Quicksand'),
        onGenerateRoute: RoutesHandler.handleRoute,
        initialRoute: homeRoute,
      ),
    );
  }
}
