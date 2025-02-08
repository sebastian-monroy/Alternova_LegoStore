import 'package:alternova_prueba/providers/cart_provider.dart';
import 'package:alternova_prueba/providers/product_provider.dart';
import 'package:alternova_prueba/providers/theme_provider.dart';
import 'package:alternova_prueba/screens/cart_screen.dart';
import 'package:alternova_prueba/screens/product_detail_screen.dart';
import 'package:alternova_prueba/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final authService = Provider.of<AuthService>(context, listen: false);

    final producstProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tienda Lego',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.indigo,
        actions:[
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white,),
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => CartScreen())
                  );
                }, 
              ),
              if(cartProvider.cart.isNotEmpty)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                  ),
                  child: Text(
                    cartProvider.cart.length.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              )
            ],
          ),
          IconButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            }, 
            icon: Icon(Icons.login_outlined, color: Colors.white)
          ),
        ] 
      ),
      body: FutureBuilder(
        future: _productsFuture, 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }

          return ListView.builder(
            itemCount: producstProvider.products.length,
            itemBuilder: (context, index){
              final product = producstProvider.products[index];

              return Card(
                child: ListTile(
                  leading: Image.network(product.image, width: 50,),
                  title: Text(product.name),
                  subtitle: Text('\$${product.unitPrice} • Stock: ${product.stock}'),
                  trailing: IconButton(
                    onPressed: product.stock > 0 ? ()=> cartProvider.addToCart(product) : null, 
                    icon: Icon(Icons.add_shopping_cart)
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ProductDetailScreen(product)),
                    );
                  },
                ),
              );
            }
          );
        }
      )
    );
  }
}