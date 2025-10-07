// models/product.dart - Product model
import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final int price;
  final String? imageUrl;
  final IconData icon;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.icon = Icons.local_drink,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'iconCode': icon.codePoint,
  };

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    imageUrl: json['imageUrl'],
    icon: IconData(json['iconCode'] ?? 0xe532, fontFamily: 'MaterialIcons'),
  );
}