// screens/returns_screen.dart
import 'package:flutter/material.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ استدعاء ألوان الثوابت

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المرتجعات"),
        centerTitle: true,
        backgroundColor: AppColors.primary, // ✅ لون موحد مع النظام
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.undo, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              "لا توجد طلبات مرتجعة حالياً",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "يمكنك تقديم طلب إرجاع من خلال صفحة تفاصيل الطلب في حال كان المنتج مؤهلاً.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
