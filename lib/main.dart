import 'package:app_maxall2/providers/ThemeProvider.dart';
import 'package:app_maxall2/screens/Orders/orders_screen.dart';
import 'package:app_maxall2/screens/favorites_screen.dart';
import 'package:app_maxall2/screens/returns_screen.dart';
import 'package:app_maxall2/screens/splash_screen.dart';
import 'package:app_maxall2/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maxalll Ecommerce',
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      home: const SplashScreen(),
      routes: {
        "/orders": (context) => OrdersScreen(),
        "/returns": (context) => ReturnsScreen(),
        "/favorites": (context) => FavoritesScreen(),
        "/credits": (context) => WalletScreen(),
        "/login": (context) => LoginScreen(),
      },
    );
  }
}
