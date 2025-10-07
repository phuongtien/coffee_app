// providers/tables_provider.dart - Tables state management
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/game_table.dart';
import '../models/product.dart';
import '../core/firebase_service.dart';

class TablesProvider extends ChangeNotifier {
  List<GameTable> _tables = [];
  StreamSubscription? _subscription;
  bool _isInitialized = false;

  List<GameTable> get tables => _tables;
  bool get isInitialized => _isInitialized;

  TablesProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final loaded = await FirebaseService.loadTables().timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );

      if (loaded.isEmpty) {
        _tables = _getDefaultTables();
        await FirebaseService.saveTables(_tables);
      } else {
        _tables = loaded;
      }

      _isInitialized = true;
      notifyListeners();

      _subscription = FirebaseService.watchTables().listen(
            (updatedTables) {
          _tables = updatedTables;
          notifyListeners();
        },
        onError: (e) => debugPrint('Watch tables error: $e'),
      );
    } catch (e) {
      debugPrint('Initialize tables error: $e');
      _tables = _getDefaultTables();
      _isInitialized = true;
      notifyListeners();
    }
  }

  List<GameTable> _getDefaultTables() {
    return [
      GameTable(id: 1, name: 'Bàn 3 bi #1', ratePerHour: 25000),
      GameTable(id: 2, name: 'Bàn 3 bi #2', ratePerHour: 25000),
      GameTable(id: 3, name: 'Bàn lỗ #1', ratePerHour: 30000),
    ];
  }

  Future<void> startTable(int id) async {
    final table = _tables.firstWhere((t) => t.id == id);
    table.start();
    notifyListeners();
    await FirebaseService.saveTable(table);
  }

  Future<void> stopTable(int id) async {
    final table = _tables.firstWhere((t) => t.id == id);
    table.stop();
    notifyListeners();
    await FirebaseService.saveTable(table);
  }

  Future<void> resetTable(int id) async {
    final table = _tables.firstWhere((t) => t.id == id);
    table.reset();
    notifyListeners();
    await FirebaseService.saveTable(table);
  }

  Future<void> addOrderToTable(int tableId, Product product) async {
    final table = _tables.firstWhere((t) => t.id == tableId);
    table.addOrder(product);
    notifyListeners();
    await FirebaseService.saveTable(table);
  }

  Future<void> updateTableOrder(int tableId, Product product, int delta) async {
    final table = _tables.firstWhere((t) => t.id == tableId);
    table.updateOrderQuantity(product, delta);
    notifyListeners();
    await FirebaseService.saveTable(table);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}