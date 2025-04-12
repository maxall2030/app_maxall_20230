// viewers/widgets/widget_account.dart
import 'package:app_maxall2/screens/favorites_screen.dart';
import 'package:app_maxall2/screens/returns_screen.dart';
import 'package:app_maxall2/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
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
      childAspectRatio: 1.9, // ✅ لتصغير حجم البطاقات قليلاً
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
          icon: Icons.assignment,
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
          icon: Icons.account_balance_wallet,
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
