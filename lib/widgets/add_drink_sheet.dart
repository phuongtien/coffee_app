// widgets/add_drink_sheet.dart - Bottom sheet for adding drinks
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_table.dart';
import '../providers/tables_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class AddDrinkSheet extends StatelessWidget {
  final GameTable table;

  const AddDrinkSheet({super.key, required this.table});

  static void show(BuildContext context, GameTable table) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddDrinkSheet(table: table),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            _buildHandle(),
            _buildTitle(),
            Expanded(child: _buildGrid(context, scrollController)),
          ],
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Chọn đồ uống',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, ScrollController scrollController) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: AppConstants.sampleProducts.length,
      itemBuilder: (context, i) {
        final product = AppConstants.sampleProducts[i];

        return Card(
          elevation: 2,
          child: InkWell(
            onTap: () => _addDrink(context, product),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(product.icon, size: 48, color: Colors.orange),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatVND(product.price),
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addDrink(BuildContext context, product) {
    context.read<TablesProvider>().addOrderToTable(table.id, product);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm ${product.name}')),
    );
  }
}