import 'package:flutter/material.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/services/api_favorites.dart';
import 'package:app_maxall2/model/products_data.dart';
import 'package:app_maxall2/components/product_card.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ إضافة استدعاء الألوان الموحدة

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> favoriteProducts = [];
  bool isLoading = true;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchFavorites();
  }

  Future<void> _loadUserIdAndFetchFavorites() async {
    userId = await UserSession.getUserId();
    await fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiFavorites.getFavorites(userId);
      setState(() {
        favoriteProducts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        favoriteProducts = [];
        isLoading = false;
      });
      print("❌ خطأ أثناء جلب المفضلة: $e");
    }
  }

  void removeFromFavorites(int productId) {
    setState(() {
      favoriteProducts.removeWhere((p) => p.id == productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteProducts.isEmpty
              ? const Center(child: Text("لا توجد عناصر في المفضلة"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: favoriteProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                ),
    );
  }
}
