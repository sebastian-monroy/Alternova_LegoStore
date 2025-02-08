import 'package:alternova_prueba/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

Future<void> _buyProducts(BuildContext context) async {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

  final url = Uri.parse('https://1be9db56-c889-466d-9c12-cba178414901.mock.pstmn.io/buy');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      "products": cartProvider.cart.entries.map((e) => {"id": e.key, "quantity": e.value}).toList(),
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey("products")) {
      productsProvider.updateStock(responseData["products"]);
    }

    cartProvider.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compra realizada con éxito")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.indigo,
        title: Text("Carrito", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: cartProvider.cart.isEmpty
          ? Center(
              child: Text(
                "El carrito está vacío",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cart.length,
                    itemBuilder: (context, index) {
                      final productId = cartProvider.cart.keys.elementAt(index);
                      final quantity = cartProvider.cart[productId]!;

                      final product = productsProvider.products.firstWhere((element) => element.id == productId);
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: product != null
                              ? Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover)
                              : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          title: Text(
                            product?.name ?? "Producto desconocido",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Cantidad: $quantity"),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _buyProducts(context),
                    icon: Icon(Icons.payment, color: Colors.white),
                    label: Text("Comprar", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
