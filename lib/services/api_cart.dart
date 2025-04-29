// services/api_cart.dart
import 'dart:convert';
// ignore: unused_import
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/products_data.dart';

class ApiCart {
  static const String baseUrl = "http://10.0.2.2/Maxall_php/download/";

  static Future<bool> addToCart(int userId, int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}add_pro_tocart.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "product_id": productId,
          "quantity": quantity,
        }),
      );

      print("📡 إضافة للسلة => ${response.statusCode}");
      print("📥 الرد: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["status"] == "success";
      }
      return false;
    } catch (e) {
      print("❌ خطأ أثناء الإضافة: $e");
      return false;
    }
  }

  static Future<bool> updateCartItem(
      int userId, int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}update_cart.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "product_id": productId,
          "quantity": quantity,
        }),
      );

      print("📡 تحديث سلة => ${response.statusCode}");
      print("📥 الرد: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["status"] == "success";
      }
      return false;
    } catch (e) {
      print("❌ خطأ أثناء التحديث: $e");
      return false;
    }
  }

  static Future<List<Product>> fetchCartProducts(int userId) async {
    try {
      final url = "${baseUrl}get_pro_cart.php?user_id=$userId";
      print("📡 جلب المنتجات في السلة للمستخدم $userId");

      final response = await http.get(Uri.parse(url));
      print("🔍 الرد: ${response.statusCode}");
      print("📥 البيانات: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success" && data["cart"] is List) {
          Map<int, Product> uniqueProducts = {};
          for (var json in data["cart"]) {
            try {
              int productId = int.tryParse(json["id"].toString()) ?? 0;
              int quantity = int.tryParse(json["quantity"].toString()) ?? 1;

              if (uniqueProducts.containsKey(productId)) {
                uniqueProducts[productId] = uniqueProducts[productId]!.copyWith(
                  quantity: uniqueProducts[productId]!.quantity + quantity,
                );
              } else {
                uniqueProducts[productId] = Product.fromJson(json);
              }
            } catch (e) {
              print("❌ خطأ في التحويل: $e");
            }
          }

          return uniqueProducts.values.toList();
        } else {
          print("⚠ استجابة غير متوقعة: ${data["status"]}");
        }
      }
      return [];
    } catch (e) {
      print("❌ خطأ أثناء جلب السلة: $e");
      return [];
    }
  }
}
