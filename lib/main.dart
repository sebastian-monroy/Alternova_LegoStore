import 'package:alternova_prueba/providers/cart_provider.dart';
import 'package:alternova_prueba/providers/product_provider.dart';
import 'package:alternova_prueba/providers/theme_provider.dart';
import 'package:alternova_prueba/screens/screens.dart';
import 'package:alternova_prueba/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/register_screen.dart';

void main() => runApp(const AppState());


class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themePorvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themePorvider.lightTheme,
      darkTheme: themePorvider.darkTheme,
      themeMode: themePorvider.themeMode,
      title: 'Alternova prueba',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'home': (_)=> HomeScreen()
      },
    );
  }
}