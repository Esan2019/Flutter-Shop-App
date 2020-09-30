import 'package:flutter/cupertino.dart';

import './routes/home.dart';
import './routes/product_overview.dart';
import './models/product.dart';

const homeRoute = '/';
const productOverviewRoute = '/product-overview';

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
    }
  }
}
