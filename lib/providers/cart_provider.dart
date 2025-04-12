// providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../services/api_cart.dart';
import '../model/products_data.dart';
import 'package:app_maxall2/utils/user_session.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> fetchCart(int userId) async {
    try {
      _cartItems = await ApiCart.fetchCartProducts(userId);
      notifyListeners();
    } catch (e, stackTrace) {
      print("⚠ خطأ أثناء جلب السلة: $e");
      print("📌 تفاصيل الخطأ: $stackTrace");
    }
  }

  Future<void> addToCart(Product product) async {
    final userId = await UserSession.getUserId(); // ✅ جلب userId

    int index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _cartItems[index] =
          _cartItems[index].copyWith(quantity: _cartItems[index].quantity + 1);
    } else {
      _cartItems.add(product.copyWith(quantity: 1));
    }

    bool success = await ApiCart.addToCart(userId, product.id, 1);
    if (!success) {
      print("⚠ فشل في إضافة المنتج إلى قاعدة البيانات.");
    }

    notifyListeners();
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    final userId = await UserSession.getUserId(); // ✅ جلب userId

    int index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      if (newQuantity < 1) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }

      bool success =
          await ApiCart.updateCartItem(userId, product.id, newQuantity);
      if (!success) {
        print("⚠ فشل في تحديث الكمية في قاعدة البيانات.");
      }

      notifyListeners();
    }
  }
}
