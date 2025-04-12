// services/api_categories.dart
import 'dart:convert';
import 'dart:io';
import 'package:app_maxall2/services/api_link.dart';
import 'package:http/http.dart' as http;
import '../model/categories_data.dart';

class ApiCategories {
  // 🔹 استخدم 10.0.2.2 للمحاكي أو IP الجهاز الحقيقي

  /// ✅ جلب الفئات من API
  static Future<List<Category>> fetchCategories() async {
    try {
      print("📡 جاري الاتصال بـ API الفئات: $linkcategories ...");

      final response = await http.get(Uri.parse(linkcategories));
      print("🔍 استجابة السيرفر: ${response.statusCode}");

      if (response.statusCode == 200) {
        print(
            "📩 البيانات المستلمة:\n${response.body}"); // ✅ طباعة البيانات للتأكد

        final data = json.decode(response.body);
        if (data["status"] == "success" && data["categories"] is List) {
          print("📦 عدد الفئات المسترجعة: ${data["categories"].length}");
          return data["categories"]
              .map<Category>((json) => Category.fromJson(json))
              .toList();
        } else {
          throw Exception("⚠️ البيانات غير متوافقة مع المتطلبات.");
        }
      } else {
        throw Exception("⚠️ فشل في الاتصال بالسيرفر، تأكد من تشغيل XAMPP.");
      }
    } on SocketException catch (e) {
      print("🚨 مشكلة في الاتصال بالإنترنت أو السيرفر: ${e.message}");
      throw Exception("⚠️ لا يوجد اتصال بالسيرفر. تأكد من أن XAMPP يعمل.");
    } on HttpException catch (e) {
      print("🚨 خطأ في HTTP: ${e.message}");
      throw Exception("⚠️ فشل في الاتصال بالسيرفر. تحقق من إعدادات الشبكة.");
    } catch (e) {
      print("❌ خطأ غير معروف: $e");
      throw Exception("⚠️ خطأ غير معروف، تأكد من إعدادات السيرفر و`baseUrl`.");
    }
  }
}
