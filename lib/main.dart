import 'package:flutter/material.dart';

import 'routes_handler.dart';

void main() => runApp(ShopApp());

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      theme: ThemeData(
        primaryColor: const Color(0xFFeebdff),
        accentColor: const Color(0xFFdf99f7),
        appBarTheme: AppBarTheme(color: const Color(0xFFeebdff)),
        scaffoldBackgroundColor: const Color(0xFFf5d9ff),
        fontFamily: 'Quicksand'
      ),
      onGenerateRoute: RoutesHandler.handleRoute,
      initialRoute: homeRoute,
    );
  }
}
