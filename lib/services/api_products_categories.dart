// services/api_products_categories.dart
import 'dart:convert';
import 'dart:io';
import 'package:app_maxall2/services/api_link.dart';
import 'package:http/http.dart' as http;
import '../model/products_data.dart';

class ApiProducts {
  /// ✅ جلب المنتجات حسب الفئة
  static Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    try {
      final url = "$linkget_products_by_category$categoryId";
      print("📡 جاري جلب المنتجات لفئة: $categoryId ...");

      final response = await http.get(Uri.parse(url));
      print("🔍 استجابة السيرفر: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success" && data["products"] is List) {
          return data["products"]
              .map<Product>((json) => Product.fromJson(json))
              .toList();
        } else {
          throw Exception("⚠️ البيانات غير متوافقة.");
        }
      } else {
        throw Exception("⚠️ فشل في الاتصال بالسيرفر.");
      }
    } on SocketException {
      throw Exception("⚠️ لا يوجد اتصال بالسيرفر.");
    } catch (e) {
      throw Exception("⚠️ خطأ غير معروف: $e");
    }
  }
}
