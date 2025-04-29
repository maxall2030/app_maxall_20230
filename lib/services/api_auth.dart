// services/api_auth.dart
import 'dart:convert';
import 'package:app_maxall2/model/profile.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://172.20.10.2/Maxall_php/auth";

  /// ✅ تسجيل مستخدم جديد
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    try {
      final url = "$baseUrl/register.php";
      final headers = {"Content-Type": "application/json"};
      final body =
          jsonEncode({"name": name, "email": email, "password": password});

      print("📡 [REGISTER] إرسال طلب تسجيل مستخدم جديد إلى: $url");
      print("📦 البيانات المرسلة: $body");

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      print("🔄 استجابة السيرفر: ${response.statusCode}");
      print("📥 البيانات المستلمة: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "⚠ فشل في التسجيل"};
      }
    } catch (e) {
      print("❌ خطأ أثناء إرسال طلب التسجيل: $e");
      return {"status": "error", "message": "⚠ خطأ: $e"};
    }
  }

  /// ✅ تسجيل الدخول
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final url = "$baseUrl/login.php";
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({"email": email, "password": password});

      print("📡 [LOGIN] إرسال طلب تسجيل دخول إلى: $url");
      print("📦 البيانات المرسلة: $body");

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      print("🔄 استجابة السيرفر: ${response.statusCode}");
      print("📥 البيانات المستلمة: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ✅ التحقق من وجود المستخدم ضمن الاستجابة لتجنب null
        if (decoded["status"] == "success" && decoded["user"] != null) {
          return decoded;
        } else {
          return {
            "status": "error",
            "message": "⚠ استجابة غير متوقعة من الخادم"
          };
        }
      } else {
        return {"status": "error", "message": "⚠ فشل في تسجيل الدخول"};
      }
    } catch (e) {
      print("❌ خطأ أثناء تسجيل الدخول: $e");
      return {"status": "error", "message": "⚠ خطأ: $e"};
    }
  }

  /// ✅ جلب بيانات المستخدم
  static Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final url = "$baseUrl/profile.php?user_id=$userId";

      print("📡 [PROFILE] إرسال طلب جلب بيانات المستخدم إلى: $url");

      final response = await http.get(Uri.parse(url));

      print("🔄 استجابة السيرفر: ${response.statusCode}");
      print("📥 البيانات المستلمة: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "⚠ فشل في جلب بيانات المستخدم"};
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المستخدم: $e");
      return {"error": "⚠ خطأ: $e"};
    }
  }

  /// ✅ تحديث بيانات المستخدم
  static Future<Map<String, dynamic>> updateUserProfile(Profile profile) async {
    try {
      final url = "$baseUrl/profile.php";
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode(profile.toJson());

      print("📡 [UPDATE PROFILE] إرسال طلب التحديث إلى: $url");
      print("📦 البيانات المرسلة: $body");

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      print("🔄 استجابة السيرفر: ${response.statusCode}");
      print("📥 البيانات المستلمة: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "⚠ فشل في تحديث البيانات"};
      }
    } catch (e) {
      print("❌ خطأ أثناء تحديث بيانات المستخدم: $e");
      return {"status": "error", "message": "⚠ خطأ: $e"};
    }
  }
}
