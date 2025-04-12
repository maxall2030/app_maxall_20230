// screens/returns_screen.dart
import 'package:flutter/material.dart';

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المرتجعات")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.undo, size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text("لا توجد طلبات مرتجعة حالياً",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "يمكنك تقديم طلب إرجاع من خلال صفحة تفاصيل الطلب في حال كان المنتج مؤهلاً.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}