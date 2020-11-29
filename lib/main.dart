import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'routes_handler.dart';
import 'constants.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: shopName,
        theme: ThemeData(
          primaryColor: const Color(0xFFeebdff),
          accentColor: const Color(0xFFB12FEB),
          appBarTheme: AppBarTheme(color: const Color(0xFFeebdff)),
          scaffoldBackgroundColor: const Color(0xFFf5d9ff),
          fontFamily: 'Quicksand',
          cardTheme: CardTheme(
            color: const Color(0xFFeebdff),
            elevation: 7,
          ),
        ),
        onGenerateRoute: RoutesHandler.handleRoute,
        initialRoute: welcomeRoute,
      ),
    );
  }
}
