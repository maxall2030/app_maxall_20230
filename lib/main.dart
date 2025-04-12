// main.dart
import 'package:app_maxall2/screens/Orders/orders_screen.dart';
import 'package:app_maxall2/screens/favorites_screen.dart';
import 'package:app_maxall2/screens/returns_screen.dart';
import 'package:app_maxall2/screens/splash_screen.dart';
import 'package:app_maxall2/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maxalll Ecommerce',
        theme: ThemeData(
          primaryColor: Color(0xFF4B0082),
          scaffoldBackgroundColor: Color(0xFFF5F5F5),
        ),
        home: SplashScreen(),
        routes: {
          "/orders": (context) => OrdersScreen(),
          "/returns": (context) => ReturnsScreen(),
          "/favorites": (context) => FavoritesScreen(),
          "/credits": (context) => WalletScreen(),
          "/login": (context) => LoginScreen(),
        });
  }
}
