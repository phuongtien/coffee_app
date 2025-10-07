// widgets/cart_item_tile.dart - Cart item list tile
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../utils/formatters.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      child: ListTile(
        leading: _buildLeading(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailing(cart),
      ),
    );
  }

  Widget _buildLeading() {
    return CircleAvatar(
      backgroundColor: Colors.orange.withOpacity(0.12),
      child: Icon(item.product.icon, color: Colors.orange),
    );
  }

  Widget _buildTitle() {
    return Text(
      item.product.name,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSubtitle() {
    return Text(Formatters.formatVND(item.product.price));
  }

  Widget _buildTrailing(CartProvider cart) {
    return SizedBox(
      width: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => cart.decrease(item.product),
            icon: const Icon(Icons.remove_circle_outline, size: 22),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => cart.increase(item.product),
            icon: const Icon(Icons.add_circle_outline, size: 22),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => cart.remove(item.product),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}