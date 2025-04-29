import 'dart:convert';
import 'dart:io';
import 'package:app_maxall2/services/api_link.dart';
import 'package:http/http.dart' as http;
import '../model/products_data.dart';

class ApiService {
  /// ✅ جلب جميع المنتجات (من get_products.php)
  static Future<List<Product>> fetchProducts() async {
    try {
      print("📡 الاتصال بـ API: $linkproduct");

      final response = await http.get(Uri.parse(linkproduct));

      print("🔍 كود الاستجابة: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ البيانات المستلمة: $data");

        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception("⚠️ تنسيق غير متوقع من السيرفر");
        }
      } else {
        throw Exception(
            "⚠️ الاتصال بالسيرفر فشل، الكود: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("❌ لا يوجد اتصال بالسيرفر. تحقق من XAMPP أو الشبكة.");
    } catch (e) {
      throw Exception("⚠️ خطأ غير متوقع: $e");
    }
  }

  /// 🔍 البحث عن المنتجات حسب الكلمة (من search_products.php)
  static Future<List<Product>> searchProducts(String query) async {
    try {
      print("🔎 تنفيذ بحث عن: $query");

      final response = await http.get(Uri.parse('$linkSearch$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("📥 نتائج البحث: $data");

        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception("⚠️ استجابة البحث غير متوقعة");
        }
      } else {
        throw Exception("⚠️ البحث فشل، الكود: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ خطأ أثناء البحث: $e");
    }
  }
}
