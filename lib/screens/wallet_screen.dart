// screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ إضافة ملف الألوان

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("رصيد نون"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.account_balance_wallet,
                size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              "الرصيد الحالي",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "0.00 ﷼",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              "يمكنك استخدام رصيدك للشراء من المنصة أو استرداده حسب سياسة الاستخدام.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
