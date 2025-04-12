// services/api_favorites.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/products_data.dart';

class ApiFavorites {
  static const String _baseUrl = "http://10.0.2.2/Maxall_php/upload";

  /// ✅ جلب المفضلة
  static Future<List<Product>> getFavorites(int userId) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/favorites.php?user_id=$userId"));

    print("📡 الاستجابة: ${response.statusCode}");
    print("📥 البيانات: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        return List<Product>.from(
            data["data"].map((item) => Product.fromJson(item)));
      } else {
        throw Exception("فشل في تحميل المفضلة");
      }
    } else {
      throw Exception("خطأ في الاتصال بالخادم");
    }
  }

  /// ✅ تبديل الحالة (إضافة أو حذف) من المفضلة
  static Future<bool> toggleFavorite(int userId, int productId) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/toggle_favorite.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "product_id": productId}),
    );

    final data = jsonDecode(response.body);
    return data["status"] ==
        "added"; // true إذا تمت الإضافة، false إذا تم الحذف
  }
}
