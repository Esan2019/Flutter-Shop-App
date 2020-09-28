import 'package:flutter/material.dart';

import './routes/home.dart';

const homeRoute = '/';

class RoutesHandler {
  static Route<dynamic> _navigate(Widget destinationPage) {
    return MaterialPageRoute(builder: (_) => destinationPage);
  }

  static Route<dynamic> handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return _navigate(Home());
    }
  }
}
