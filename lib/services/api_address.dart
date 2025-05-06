import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/addresses_data.dart';

class ApiAddress {
  static const String _baseUrl = "http://10.0.2.2/Maxall_php/addresses/";

  /// ✅ جلب العناوين
  static Future<List<Address>> fetchAddresses(int userId) async {
    final url = Uri.parse("${_baseUrl}get_addresses.php?user_id=$userId");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List addressesJson = data['addresses'];
        return addressesJson.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception("⚠ فشل في تحميل العناوين: ${data['message']}");
      }
    } else {
      throw Exception("⚠ فشل الاتصال بالخادم: ${response.statusCode}");
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
      return false;
    }
  }

  /// ✅ تحديث عنوان
  static Future<bool> updateAddress({
    required int id,
    required String address,
    required String city,
    required String country,
  }) async {
    final url = Uri.parse("${_baseUrl}update_address.php");

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
    return data["status"] == "success";
  }

  /// ✅ حذف عنوان
  static Future<bool> deleteAddress(int id) async {
    final url = Uri.parse("${_baseUrl}delete_address.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"] == "success";
    } else {
      return false;
    }
  }
}
