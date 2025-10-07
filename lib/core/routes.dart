// core/routes.dart - Route management
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';

class Routes {
  static const String home = '/';
  static const String cart = '/cart';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      cart: (context) => const CartScreen(),
    };
  }
}