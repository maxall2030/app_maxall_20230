// screens/category_products_screen.dart
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/services/api_products_categories.dart';
import 'package:flutter/material.dart';
import '../model/categories_data.dart';
import '../model/products_data.dart';
import '../components/product_card.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiProducts.fetchProductsByCategory(widget.category.id); // ✅ جلب المنتجات الخاصة بالفئة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name), // ✅ عرض اسم الفئة في العنوان
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0), // ✅ إزالة userId
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("⚠ حدث خطأ أثناء تحميل المنتجات!"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("⚠ لا توجد منتجات في هذه الفئة."));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // ✅ عرض المنتجات في شبكة من عمودين
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]); // ✅ استخدام بطاقة المنتج
            },
          );
        },
      ),
    );
  }
}