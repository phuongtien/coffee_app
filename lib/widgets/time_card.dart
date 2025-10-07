// widgets/time_card.dart - Time display card for table detail
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_table.dart';
import '../providers/tables_provider.dart';
import '../utils/formatters.dart';
class TimeCard extends StatelessWidget {
  final GameTable table;
  final VoidCallback onShowAddDrink;
  final VoidCallback onShowCheckout;

  const TimeCard({
    super.key,
    required this.table,
    required this.onShowAddDrink,
    required this.onShowCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final elapsed = table.getElapsedSeconds();

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTimeDisplay(elapsed),
            const SizedBox(height: 8),
            _buildRateInfo(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          table.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: table.occupied ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        table.occupied ? 'Đang chơi' : 'Trống',
        style: TextStyle(
          color: table.occupied ? Colors.red : Colors.green[800],
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(int elapsed) {
    return Text(
      Formatters.formatDuration(elapsed),
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildRateInfo() {
    return Text(
      'Giá giờ: ${Formatters.formatVND(table.ratePerHour)}/h',
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final tablesProvider = Provider.of<TablesProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          onPressed: table.occupied ? null : () => tablesProvider.startTable(table.id),
          icon: Icons.play_arrow,
          label: 'Bắt đầu',
          color: Colors.green,
        ),
        _ActionButton(
          onPressed: table.occupied ? () => tablesProvider.stopTable(table.id) : null,
          icon: Icons.pause,
          label: 'Dừng',
          color: Colors.orange,
        ),
        _ActionButton(
          onPressed: onShowCheckout,
          icon: Icons.local_drink,
          label: 'Kết toán',
          color: Colors.blue,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? color : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}