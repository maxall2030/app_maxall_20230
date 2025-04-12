// services/api_orders.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/orders_model.dart';

class ApiOrders {
  static const String baseUrl = "http://10.0.2.2/Maxall_php/orders/";

  /// ✅ إرسال طلب إنشاء Order جديد
  static Future<bool> placeOrder(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}place_order.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      print("📡 إرسال الطلب => statusCode: ${response.statusCode}");
      print("📥 استجابة الخادم: ${response.body}");

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

      print("📡 جلب الطلبات => statusCode: ${response.statusCode}");
      print("📥 استجابة الخادم: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return (data['orders'] as List)
              .map((json) => Order.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("فشل الاتصال بالسيرفر");
      }
    } catch (e) {
      throw Exception("❌ خطأ أثناء جلب الطلبات: $e");
    }
  }
}
