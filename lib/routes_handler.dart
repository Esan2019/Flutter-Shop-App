import 'package:flutter/cupertino.dart';

import './routes/welcome_setup/welcome_screen.dart';
import './routes/welcome_setup/auth_screen.dart';
import './routes/home.dart';
import './routes/product_overview.dart';
import './routes/favorites.dart';
import './routes/cart_items.dart';
import './routes/orders_overview.dart';
import './routes/user_products.dart';
import './routes/edit_product.dart';
import './models/product.dart';

const welcomeRoute = '/';
const authRoute = '/auth';
const homeRoute = '/home';
const productOverviewRoute = '/product-overview';
const favoritesRoute = '/favorites';
const cartItemsRoute = '/cart-itens';
const ordersOverview = '/orders-overview';
const userProducts = '/user-products';
const editProduct = '/edit-product';

class RoutesHandler {
  static Route<dynamic> _navigate(Widget destinationPage) {
    return CupertinoPageRoute(builder: (_) => destinationPage);
  }

  static Route<dynamic> handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
      return _navigate(WelcomeScreen());

      case authRoute:
      final isRegistering = settings.arguments as bool;
      return _navigate(AuthScreen(isRegistering));

      case homeRoute:
        return _navigate(Home());

      case productOverviewRoute:
        final selectedProduct = settings.arguments as Product;
        return _navigate(ProductOverview(selectedProduct));

      case favoritesRoute:
        return _navigate(Favorites());

      case cartItemsRoute:
        return _navigate(CartItems());

      case ordersOverview:
        return _navigate(OrdersOverview());

      case userProducts:
        return _navigate(UserProducts());

      case editProduct:
        final arguments = settings.arguments as Map<String, dynamic>;
        final scaffold = arguments['ancestorScaffold'];

        if (arguments.containsKey('product')) {
          return _navigate(EditProduct(
            product: arguments['product'],
            ancestorScaffold: scaffold,
          ));
        } else {
          return _navigate(EditProduct(ancestorScaffold: scaffold));
        }
    }
  }
}
