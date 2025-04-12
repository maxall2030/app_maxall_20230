// screens/Orders/order_confirmation_screen.dart
import 'package:app_maxall2/screens/Orders/orders_screen.dart';
// ignore: unused_import
import 'package:app_maxall2/screens/home_screen.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تأكيد الطلب")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "✅ تم تقديم طلبك بنجاح!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "سنتواصل معك قريبًا لتأكيد تفاصيل الطلب.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
              child: Text("العودة إلى الصفحة الرئيسية"),
            )
          ],
        ),
      ),
    );
  }
}
