// screens/home_screen.dart - Home screen with tabs
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/tables_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/tables_grid.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TablesProvider>(
      builder: (context, tablesProvider, _) {
        if (!tablesProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang kết nối Firebase...'),
                ],
              ),
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: const [
                  Icon(Icons.local_cafe, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Coffee & Billboard',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              actions: [
                _buildSyncIndicator(),
                _buildCartButton(context),
                const SizedBox(width: 8),
              ],
              bottom: const TabBar(
                indicatorColor: Colors.orange,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(icon: Icon(Icons.shopping_bag), text: 'Sản phẩm'),
                  Tab(icon: Icon(Icons.sports_esports), text: 'Bàn chơi'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                ProductGrid(),
                TablesGrid(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyncIndicator() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text('Đồng bộ', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
            if (cart.totalItems > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    cart.totalItems.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}