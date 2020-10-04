import 'package:flutter/cupertino.dart';

import './routes/home.dart';
import './routes/product_overview.dart';
import './routes/favorites.dart';
import './routes/cart_items.dart';
import './models/product.dart';

const homeRoute = '/';
const productOverviewRoute = '/product-overview';
const favoritesRoute = '/favorites';
const cartItemsRoute = '/cart-itens';

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
        return _navigate(ProductOverview(selectedProduct));

      case favoritesRoute:
        return _navigate(Favorites());

      case cartItemsRoute:
        return _navigate(CartItems());
    }
  }
}
