import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import './routes/home.dart';
import './routes/product_overview.dart';
import './routes/favorites.dart';
import './models/product.dart';

const homeRoute = '/';
const productOverviewRoute = '/product-overview';
const favoritesRoute = '/favorites';

class RoutesHandler {
  static Route<dynamic> _navigate(Widget destinationPage) {
    return CupertinoPageRoute(builder: (_) => destinationPage);
  }

  static Route<dynamic> handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return _navigate(Home());

      case productOverviewRoute:
        final selectedProduct = settings.arguments as Product;
        return _navigate(
          ChangeNotifierProvider.value(
            value: selectedProduct,
            child: ProductOverview(),
          ),
        );

      case favoritesRoute:
        return _navigate(Favorites());
    }
  }
}
