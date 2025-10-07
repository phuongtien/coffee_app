// widgets/product_card.dart - Product card widget
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/formatters.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: 12),
            _buildName(),
            const SizedBox(height: 8),
            _buildPrice(),
            const Spacer(),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(product.icon, size: 40, color: Colors.orange),
    );
  }

  Widget _buildName() {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPrice() {
    return Text(
      Formatters.formatVND(product.price),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: const Icon(Icons.add_shopping_cart, size: 18),
      label: const Text('Thêm'),
      onPressed: () => _addToCart(context),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartProvider>().add(product);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${product.name} vào giỏ'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}