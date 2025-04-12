// services/api_product.dart
import 'dart:convert';
import 'dart:io';
import 'package:app_maxall2/services/api_link.dart';
import 'package:http/http.dart' as http;
import '../model/products_data.dart';

class ApiService {
  
  /// ✅ تحميل المنتجات من API مع رسائل توضيحية
  static Future<List<Product>> fetchProducts() async {
    try {
      print("📡 جاري الاتصال بـ API: $linkproduct ...");

      final response = await http.get(Uri.parse(linkproduct));

      print("🔍 استجابة السيرفر: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          print("✅ البيانات المستلمة من السيرفر: $data");

          if (data["status"] == "success" && data["products"] is List) {
            List productsJson = data["products"];
            print("📦 عدد المنتجات المسترجعة: ${productsJson.length}");
            return productsJson.map((json) => Product.fromJson(json)).toList();
          } else {
            print("⚠️ استجابة غير متوقعة من السيرفر: ${response.body}");
            throw Exception("⚠️ البيانات غير متوافقة مع المتطلبات.");
          }
        } on FormatException catch (e) {
          print("❌ خطأ في تحليل JSON: ${e.message}");
          throw Exception(
              "⚠️ بيانات JSON غير صالحة. تأكد من أن API يرجع بيانات صحيحة.");
        }
      } else {
        print("❌ خطأ في الاتصال: كود الاستجابة ${response.statusCode}");
        throw Exception("⚠️ فشل في الاتصال بالسيرفر، تأكد من تشغيل XAMPP.");
      }
    } on SocketException catch (e) {
      print("🚨 مشكلة في الاتصال بالإنترنت أو السيرفر: ${e.message}");
      throw Exception(
          "⚠️ لا يوجد اتصال بالسيرفر. تأكد من أن XAMPP يعمل، واستخدم IP الصحيح.");
    } on HttpException catch (e) {
      print("🚨 خطأ في HTTP: ${e.message}");
      throw Exception("⚠️ فشل في الاتصال بالسيرفر. تحقق من إعدادات الشبكة.");
    } catch (e) {
      print("❌ خطأ غير معروف: $e");
      throw Exception("⚠️ خطأ غير معروف، تأكد من إعدادات السيرفر و`baseUrl`.");
    }
  }
}
