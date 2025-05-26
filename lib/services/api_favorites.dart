import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/products_data.dart';
import 'api_link.dart';

class ApiFavorites {
  static Future<List<Product>> getFavorites(int userId) async {
    final url = Uri.parse('$linkGetFavorites?user_id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("فشل في تحميل المنتجات المفضلة");
    }
  }

  static Future<bool> toggleFavorite(int userId, int productId) async {
    final url = Uri.parse(linkToggleFavorite);
    final response = await http.post(url, body: {
      'user_id': userId.toString(),
      'product_id': productId.toString(),
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['status'] == 'added';
    } else {
      return false;
    }
  }

  static Future<bool> checkIfFavorite(int userId, int productId) async {
    final url =
        Uri.parse('$linkCheckFavorite?user_id=$userId&product_id=$productId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['isFavorite'] == true;
    } else {
      return false;
    }
  }
}
