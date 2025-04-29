import 'package:flutter/material.dart';
import 'package:app_maxall2/screens/favorites_screen.dart';
import 'package:app_maxall2/screens/returns_screen.dart';
import 'package:app_maxall2/screens/wallet_screen.dart';
import 'package:app_maxall2/screens/Orders/orders_screen.dart';

class AccountSummaryWidget extends StatelessWidget {
  const AccountSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      childAspectRatio: 1.65, // ✅ قللنا النسبة لحل مشكلة overflow
      children: [
        _buildItem(
          context: context,
          title: "المرتجعات",
          subtitle: "0 طلب نشط",
          icon: Icons.history,
          screen: const ReturnsScreen(),
        ),
        _buildItem(
          context: context,
          title: "الطلبات",
          subtitle: "تتبع الطلبات",
          icon: Icons.assignment_outlined,
          screen: const OrdersScreen(),
        ),
        _buildItem(
          context: context,
          title: "المفضلة",
          subtitle: "2 منتج محفوظ",
          icon: Icons.favorite_border,
          screen: const FavoritesScreen(),
        ),
        _buildItem(
          context: context,
          title: "الرصيد",
          subtitle: "﷼ 0.00",
          icon: Icons.account_balance_wallet_outlined,
          screen: const WalletScreen(),
        ),
      ],
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget screen,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: theme.colorScheme.primary),
            const SizedBox(height: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
