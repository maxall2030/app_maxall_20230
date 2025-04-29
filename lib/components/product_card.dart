import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_screen.dart';
import '../constants/colors.dart';
import '../model/products_data.dart';
import '../providers/cart_provider.dart';
import '../services/api_favorites.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // ✅ لاحقاً يمكن التحقق من الحالة الفعلية من السيرفر أو الـ Provider
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    int userId = 2; // ✅ لاحقاً يتم استبداله بالمستخدم الحقيقي

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: widget.product),
          ),
        );
      },
      child: SizedBox(
        width: 160,
        child: Card(
          elevation: 2,
          color: Theme.of(context).cardColor, // ✅ لون البطاقة حسب الثيم
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.product.image,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color:
                            AppColors.textSecondary, // ✅ لون الأيقونة عند الخطأ
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      radius: 14,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        onPressed: () async {
                          final success = await ApiFavorites.toggleFavorite(
                              userId, widget.product.id);

                          if (success) {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? (isFavorite
                                      ? "✅ تمت الإضافة إلى المفضلة"
                                      : "❌ تمت الإزالة من المفضلة")
                                  : "⚠ حدث خطأ أثناء التحديث"),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      radius: 14,
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart,
                            color: AppColors.primary, size: 16),
                        onPressed: () async {
                          await cartProvider.addToCart(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "✅ ${widget.product.name} تمت إضافته إلى السلة!"),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color, // ✅ لون النص حسب الثيم
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.product.price} ر.س',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.product.rating > 0)
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.rating.toStringAsFixed(1)} ⭐ (${widget.product.reviews}K)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary, // ✅ لون التقييمات
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
