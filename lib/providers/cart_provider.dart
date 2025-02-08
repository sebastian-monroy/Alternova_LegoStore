import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> _cart = {}; 

  Map<int, int> get cart => _cart;

  void addToCart(Product product) {
    if (product.stock > 0) {
      _cart.update(product.id, (quantity) => quantity + 1, ifAbsent: () => 1);
      product.stock--;
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    if (_cart.containsKey(product.id)) {
      _cart.update(product.id, (quantity) => quantity - 1);
      if (_cart[product.id] == 0) _cart.remove(product.id);
      product.stock++;
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
