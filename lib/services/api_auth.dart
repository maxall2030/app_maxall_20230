import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_maxall2/model/profile.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2/Maxall_php/auth";

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final url = "$baseUrl/login.php";
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "email": email,
        "password": password,
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // ✅ يرجع Map مباشرة عشان تستخدمه مع response["status"] و response["user"]
      } else {
        return {"status": "error", "message": "⚠ فشل الاتصال بالخادم"};
      }
    } catch (e) {
      return {"status": "error", "message": "⚠ خطأ: $e"};
    }
  }

  static Future<Profile?> getUserProfile(int userId) async {
    try {
      final url = "$baseUrl/profile.php?user_id=$userId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          return Profile.fromJson(data["data"]);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(Profile profile) async {
    try {
      final url = "$baseUrl/profile.php";
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode(profile.toJson());

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "⚠ فشل تحديث البيانات"};
      }
    } catch (e) {
      return {"status": "error", "message": "⚠ خطأ: $e"};
    }
  }

// ✅ تسجيل مستخدم جديد
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    try {
      final url = "$baseUrl/register.php"; // مسار ملف التسجيل
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // ✅ يرجع Map مباشرة مثل {"status": "success", "message": "تم التسجيل بنجاح"}
      } else {
        return {"status": "error", "message": "⚠ فشل في الاتصال بالخادم"};
      }
    } catch (e) {
      return {"status": "error", "message": "⚠ خطأ: $e"};
    }
  }
}
