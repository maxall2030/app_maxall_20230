import 'dart:convert';
import 'dart:io';
import 'package:app_maxall2/services/api_link.dart';
import 'package:http/http.dart' as http;
import '../model/categories_data.dart';

class ApiCategories {
  /// ✅ جلب الفئات (الرئيسية فقط) بالطريقة القديمة
  static Future<List<Category>> fetchCategories() async {
    try {
      print("📡 جاري الاتصال بـ API الفئات: $linkcategories ...");

      final response = await http.get(Uri.parse(linkcategories));
      print("🔍 استجابة السيرفر: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("📩 البيانات المستلمة:\n${response.body}");

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
      throw Exception("⚠️ لا يوجد اتصال بالسيرفر.");
    } on HttpException catch (e) {
      print("🚨 خطأ في HTTP: ${e.message}");
      throw Exception("⚠️ فشل في الاتصال بالسيرفر.");
    } catch (e) {
      print("❌ خطأ غير معروف: $e");
      throw Exception("⚠️ خطأ غير معروف.");
    }
  }

  /// ✅ دالة جديدة: جلب كل الفئات (رئيسية + فرعية)
  static Future<List<Category>> getAllCategories() async {
    try {
      print("📡 الاتصال بـ API كل الفئات: $linkcategories");

      final response = await http.get(Uri.parse(linkcategories));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        print("📦 عدد الفئات الكلي: ${data.length}");

        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception("⚠️ فشل في تحميل جميع الفئات.");
      }
    } catch (e) {
      print("❌ خطأ في getAllCategories: $e");
      throw Exception("⚠️ فشل في تحميل الفئات.");
    }
  }
}
