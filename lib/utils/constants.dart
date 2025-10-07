// utils/constants.dart - App constants
import 'package:flutter/material.dart';
import '../models/product.dart';

class AppConstants {
  static const String appName = 'Coffee & Billboard';

  static final List<Product> sampleProducts = [
    Product(id: 1, name: 'Nước ngọt', price: 12000, icon: Icons.local_drink),
    Product(id: 2, name: 'Trà đường', price: 8000, icon: Icons.emoji_food_beverage),
    Product(id: 3, name: 'Cà phê', price: 10000, icon: Icons.coffee),
    Product(id: 4, name: 'Cà phê sữa', price: 15000, icon: Icons.coffee),
    Product(id: 5, name: 'Rau má', price: 10000, icon: Icons.local_drink),
    Product(id: 6, name: 'Rau má sữa', price: 15000, icon: Icons.local_drink),
    Product(id: 7, name: 'Lipton', price: 12000, icon: Icons.emoji_food_beverage),
    Product(id: 8, name: 'Đá chanh', price: 8000, icon: Icons.local_cafe),
    Product(id: 9, name: 'Chanh muối', price: 8000, icon: Icons.local_cafe),
  ];
}