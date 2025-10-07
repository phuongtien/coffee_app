// models/game_table.dart - Game table model
import 'product.dart';
import 'cart_item.dart';

class GameTable {
  final int id;
  final String name;
  final int ratePerHour;
  bool occupied;
  DateTime? startTime;
  int accumulatedSeconds;
  final List<CartItem> orders;

  GameTable({
    required this.id,
    required this.name,
    required this.ratePerHour,
    this.occupied = false,
    this.startTime,
    this.accumulatedSeconds = 0,
    List<CartItem>? orders,
  }) : orders = orders ?? [];

  void start() {
    if (!occupied) {
      occupied = true;
      startTime = DateTime.now();
    }
  }

  void stop() {
    if (occupied && startTime != null) {
      accumulatedSeconds += DateTime.now().difference(startTime!).inSeconds;
      occupied = false;
      startTime = null;
    }
  }

  void reset() {
    occupied = false;
    startTime = null;
    accumulatedSeconds = 0;
    orders.clear();
  }

  int getElapsedSeconds() {
    int total = accumulatedSeconds;
    if (occupied && startTime != null) {
      total += DateTime.now().difference(startTime!).inSeconds;
    }
    return total;
  }

  void addOrder(Product product) {
    final existing = orders.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existing.quantity == 0) {
      orders.add(CartItem(product: product, quantity: 1));
    } else {
      existing.quantity++;
    }
  }

  void updateOrderQuantity(Product product, int delta) {
    final item = orders.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (item.quantity > 0) {
      item.quantity += delta;
      if (item.quantity <= 0) {
        orders.remove(item);
      }
    }
  }

  int getOrdersTotal() {
    return orders.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int getTimeCost() {
    final elapsed = getElapsedSeconds();
    return (elapsed / 3600 * ratePerHour).round();
  }

  int getTotalCost() {
    return getTimeCost() + getOrdersTotal();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ratePerHour': ratePerHour,
    'occupied': occupied,
    'startTime': startTime?.millisecondsSinceEpoch,
    'accumulatedSeconds': accumulatedSeconds,
    'orders': orders.map((e) => e.toJson()).toList(),
  };

  factory GameTable.fromJson(Map<dynamic, dynamic> json) => GameTable(
    id: json['id'],
    name: json['name'],
    ratePerHour: json['ratePerHour'],
    occupied: json['occupied'] ?? false,
    startTime: json['startTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['startTime'])
        : null,
    accumulatedSeconds: json['accumulatedSeconds'] ?? 0,
    orders: (json['orders'] as List?)
        ?.map((e) => CartItem.fromJson(e))
        .toList() ??
        [],
  );
}