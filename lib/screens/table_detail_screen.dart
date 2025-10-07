// screens/table_detail_screen.dart - Table detail and management
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_table.dart';
import '../providers/tables_provider.dart';
import '../widgets/time_card.dart';
import '../widgets/orders_card.dart';
import '../widgets/add_drink_sheet.dart';
import '../utils/formatters.dart';

class TableDetailScreen extends StatefulWidget {
  final GameTable table;

  const TableDetailScreen({super.key, required this.table});

  @override
  State<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final table = widget.table;

    return Scaffold(
      appBar: AppBar(
        title: Text(table.name),
        actions: [
          IconButton(
            onPressed: () => _showResetDialog(context, table),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          TimeCard(
            table: table,
            onShowAddDrink: _showAddDrinkSheet,
            onShowCheckout: _showCheckoutDialog
          ),
          const SizedBox(height: 12),
          Expanded(
            child: OrdersCard(
              table: table,
              onShowAddDrink: _showAddDrinkSheet,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDrinkSheet() {
    AddDrinkSheet.show(context, widget.table);
  }

  void _showResetDialog(BuildContext context, GameTable table) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset bàn'),
        content: const Text('Bạn có chắc muốn reset (xóa giờ + đơn)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<TablesProvider>(context, listen: false)
                  .resetTable(table.id);
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog() {
    final table = widget.table;
    final elapsed = table.getElapsedSeconds();
    final timeCost = table.getTimeCost();
    final ordersCost = table.getOrdersTotal();
    final total = table.getTotalCost();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('Kết toán'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow('Thời gian', Formatters.formatDuration(elapsed)),
            const SizedBox(height: 8),
            _buildSummaryRow('Tiền giờ', Formatters.formatVND(timeCost)),
            const SizedBox(height: 8),
            _buildSummaryRow('Tiền nước', Formatters.formatVND(ordersCost)),
            const Divider(height: 24),
            _buildSummaryRow('TỔNG CỘNG', Formatters.formatVND(total), bold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TablesProvider>(context, listen: false)
                  .resetTable(widget.table.id);
              Navigator.pop(dctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã kết toán thành công')),
              );
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool bold = false}) {
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