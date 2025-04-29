// services/api_address.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/addresses_data.dart';

class ApiAddress {
  static const String _baseUrl = "http://10.0.2.2/Maxall_php/addresses/";

  /// ✅ جلب العناوين من الخادم
  static Future<List<Address>> fetchAddresses(int userId) async {
    final url = Uri.parse("${_baseUrl}get_addresses.php?user_id=$userId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        List addressesJson = data['addresses'];
        return addressesJson.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception("فشل في تحميل العناوين: ${data['message']}");
      }
    } else {
      throw Exception("فشل الاتصال بالخادم: ${response.statusCode}");
    }
  }

  /// ✅ إضافة عنوان جديد
  static Future<bool> addAddress({
    required int userId,
    required String address,
    required String city,
    required String country,
  }) async {
    final url = Uri.parse("${_baseUrl}add_address.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "address": address,
        "city": city,
        "country": country,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"] == "success";
    } else {
      print("❌ خطأ أثناء الإضافة: ${response.body}");
      return false;
    }
  }

  /// ✅ تحديث العنوان الحالي
  static Future<bool> updateAddress({
    required int id,
    required String address,
    required String city,
    required String country,
  }) async {
    final url = Uri.parse("${_baseUrl}update_address.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "address": address,
          "city": city,
          "country": country,
        }),
      );

      final data = jsonDecode(response.body);
      print("📥 استجابة تحديث العنوان: $data");

      return data["status"] == "success";
    } catch (e) {
      print("❌ استثناء أثناء تحديث العنوان: $e");
      return false;
    }
  }
}
