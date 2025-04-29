import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/components/categories_list.dart';
import 'package:app_maxall2/components/product_card.dart';
import 'package:app_maxall2/components/search_bar.dart';
import 'package:app_maxall2/services/api_product.dart';
import '../constants/colors.dart';
import '../model/products_data.dart';
import '../model/banners_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> products = await ApiService.fetchProducts();
      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          // ✅ خلفية الصورة مع شريط البحث المنخفض
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/header_bg.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.9) // الوضع الليلي
                            : Colors.white.withOpacity(0.9), // الوضع النهاري
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 45,
                child: CustomSearchBar(),
              ),
            ),
            centerTitle: true,
          ),

          SliverToBoxAdapter(child: CategoryList()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'TOP DEALS IN ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: 'ELECTRONICS',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'VIEW ALL',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: bannerImages.map((banner) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(banner.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "منتجات مميزة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ProductCard(product: filteredProducts[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "الأكثر مبيعًا",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(product: filteredProducts[index]);
                },
                childCount: filteredProducts.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
