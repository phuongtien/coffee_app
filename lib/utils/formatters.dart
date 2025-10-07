// utils/formatters.dart - Formatting utilities
class Formatters {
  static String formatVND(int amount) {
    final s = amount.toString();
    final reg = RegExp(r'(\d)(?=(\d{3})+$)');
    final out = s.replaceAllMapped(reg, (m) => '${m[1]}.');
    return '$out đ';
  }

  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${mins.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}