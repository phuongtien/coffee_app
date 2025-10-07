// providers/cart_provider.dart - Cart state management
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  void increase(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
      notifyListeners();
    }
  }

  void decrease(Product product) {
    if (!_items.containsKey(product.id)) return;

    final item = _items[product.id]!;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}