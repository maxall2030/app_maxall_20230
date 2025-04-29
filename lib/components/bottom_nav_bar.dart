// components/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart'; // ✅ استدعاء الثوابت
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/auth/account_screen.dart';
import '../providers/cart_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = HomeScreen();
        break;
      case 1:
        nextScreen = ChangeNotifierProvider.value(
          value: Provider.of<CartProvider>(context, listen: false),
          child: CartScreen(),
        );
        break;
      case 2:
        nextScreen = FavoritesScreen();
        break;
      case 3:
        nextScreen = AccountScreen();
        break;
      default:
        nextScreen = HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    int safeIndex = (currentIndex >= 0 && currentIndex < 4) ? currentIndex : 0;

    return BottomNavigationBar(
      currentIndex: safeIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // ✅ خلفية حسب الثيم
      selectedItemColor: AppColors.primary, // ✅ لون محدد حسب الثوابت
      unselectedItemColor:
          AppColors.textSecondary, // ✅ لون غير محدد حسب الثوابت
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Account",
        ),
      ],
    );
  }
}
