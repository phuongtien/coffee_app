// widgets/orders_card.dart - Orders display card
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_table.dart';
import '../providers/tables_provider.dart';
import '../utils/formatters.dart';

class OrdersCard extends StatelessWidget {
  final GameTable table;
  final VoidCallback onShowAddDrink;

  const OrdersCard({
    super.key,
    required this.table,
    required this.onShowAddDrink,
  });

  @override
  Widget build(BuildContext context) {
    final timeCost = table.getTimeCost();
    final ordersCost = table.getOrdersTotal();
    final total = table.getTotalCost();

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(child: _buildOrdersList(context)),
            const Divider(height: 24),
            _buildSummary(timeCost, ordersCost, total),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Đơn nước',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        ElevatedButton.icon(
          onPressed: onShowAddDrink,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Thêm'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    if (table.orders.isEmpty) {
      return _buildEmptyOrders();
    }

    return ListView.separated(
      itemCount: table.orders.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, idx) {
        final item = table.orders[idx];
        final tablesProvider = Provider.of<TablesProvider>(context, listen: false);

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.orange.withOpacity(0.12),
            child: Icon(item.product.icon, color: Colors.orange),
          ),
          title: Text(
            item.product.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            Formatters.formatVND(item.product.price),
            style: const TextStyle(color: Colors.deepOrange),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => tablesProvider.updateTableOrder(
                  table.id,
                  item.product,
                  -1,
                ),
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.red,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => tablesProvider.updateTableOrder(
                  table.id,
                  item.product,
                  1,
                ),
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Chưa có order',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int timeCost, int ordersCost, int total) {
    return Column(
      children: [
        _SummaryRow(label: 'Tiền giờ', value: Formatters.formatVND(timeCost)),
        const SizedBox(height: 8),
        _SummaryRow(label: 'Tiền nước', value: Formatters.formatVND(ordersCost)),
        const Divider(height: 24),
        _SummaryRow(
          label: 'TỔNG CỘNG',
          value: Formatters.formatVND(total),
          bold: true,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            fontSize: bold ? 16 : 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            color: bold ? Colors.orange : Colors.deepOrange,
            fontSize: bold ? 18 : 15,
          ),
        ),
      ],
    );
  }
}