import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/colors.dart';
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
        nextScreen = const HomeScreen();
        break;
      case 1:
        nextScreen = ChangeNotifierProvider.value(
          value: Provider.of<CartProvider>(context, listen: false),
          child: const CartScreen(),
        );
        break;
      case 2:
        nextScreen = const FavoritesScreen();
        break;
      case 3:
        nextScreen = const AccountScreen();
        break;
      default:
        nextScreen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    int safeIndex = (currentIndex >= 0 && currentIndex < 4) ? currentIndex : 0;

    return BottomNavigationBar(
      currentIndex: safeIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: local.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart_outlined),
          activeIcon: const Icon(Icons.shopping_cart),
          label: local.cart,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_border),
          activeIcon: const Icon(Icons.favorite),
          label: local.favorites,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: local.account,
        ),
      ],
    );
  }
}
