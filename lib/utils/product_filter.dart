// utils/product_filter.dart
import '../model/products_data.dart';

/// 🟢 دالة لتصفية المنتجات حسب الاسم أو رقم المنتج
List<Product> filterProducts(String query, List<Product> allProducts) {
  return allProducts.where((product) {
    return product.name.toLowerCase().contains(query);
    //.contains(query.toLowerCase()) ||
    // product.number.toString().contains(query);
  }).toList();
}
