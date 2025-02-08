import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://1be9db56-c889-466d-9c12-cba178414901.mock.pstmn.io/all-products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _products = (data['products'] as List).map((p) => Product.fromJson(p)).toList();
      notifyListeners();
    }
  }

    void updateStock(List<dynamic> updatedProducts) {
    for (var updatedProduct in updatedProducts) {
      int index = products.indexWhere((p) => p.id == updatedProduct["id"]);
      if (index != -1) {
        products[index].stock = updatedProduct["stock"];
      }
    }
    notifyListeners();
  }
}
