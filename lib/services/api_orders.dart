// services/api_orders.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/orders_model.dart';

class ApiOrders {
  static const String baseUrl = "http://10.0.2.2/Maxall_php/orders/";

  /// ✅ إنشاء طلب جديد
  static Future<bool> placeOrder(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}place_order.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      print("📡 إرسال الطلب - StatusCode: ${response.statusCode}");
      print("📥 الرد: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["status"] == "success";
      } else {
        return false;
      }
    } catch (e) {
      print("❌ خطأ أثناء تنفيذ الطلب: $e");
      return false;
    }
  }

  /// ✅ جلب الطلبات حسب عدد الأشهر
  static Future<List<Order>> fetchOrdersByDate(int userId, int months) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}get_orders.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "months": months,
        }),
      );

      print("📡 جلب الطلبات - StatusCode: ${response.statusCode}");
      print("📥 الرد: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<Order> orders = (data['orders'] as List)
              .map((orderJson) => Order.fromJson(orderJson))
              .toList();
          return orders;
        } else {
          throw Exception("⚠ ${data['message']}");
        }
      } else {
        throw Exception("⚠ فشل الاتصال بالخادم (${response.statusCode})");
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب الطلبات: $e");
      throw Exception("❌ خطأ أثناء جلب الطلبات: $e");
    }
  }
}
