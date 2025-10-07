// widgets/table_card.dart - Table card widget
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_table.dart';
import '../screens/table_detail_screen.dart';
import '../utils/formatters.dart';

class TableCard extends StatefulWidget {
  final GameTable table;

  const TableCard({super.key, required this.table});

  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> {
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
    final elapsed = table.getElapsedSeconds();
    final timeCost = table.getTimeCost();
    final ordersCost = table.getOrdersTotal();
    final total = table.getTotalCost();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(table),
              const SizedBox(height: 8),
              _buildIcon(),
              const SizedBox(height: 8),
              _buildRate(table),
              const Spacer(),
              _buildTimeRow(elapsed),
              const SizedBox(height: 4),
              _buildOrdersRow(ordersCost),
              const Divider(height: 16),
              _buildTotalRow(total),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TableDetailScreen(table: widget.table),
      ),
    );
  }

  Widget _buildHeader(GameTable table) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            table.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusBadge(table),
      ],
    );
  }

  Widget _buildStatusBadge(GameTable table) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: table.occupied ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        table.occupied ? 'Đang chơi' : 'Trống',
        style: TextStyle(
          color: table.occupied ? Colors.red : Colors.green[800],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const Center(
      child: Icon(Icons.sports_esports, size: 48, color: Colors.orange),
    );
  }

  Widget _buildRate(GameTable table) {
    return Text(
      '${Formatters.formatVND(table.ratePerHour)}/giờ',
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTimeRow(int elapsed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Thời gian',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          Formatters.formatDuration(elapsed),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildOrdersRow(int ordersCost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Đơn nước',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          Formatters.formatVND(ordersCost),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Tổng', style: TextStyle(fontWeight: FontWeight.w700)),
        Text(
          Formatters.formatVND(total),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.orange,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}