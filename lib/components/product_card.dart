import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/product_screen.dart';
import '../constants/colors.dart';
import '../model/products_data.dart';
import '../providers/cart_provider.dart';
import '../services/api_favorites.dart';
import '../utils/user_session.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool showFavorite;
  final bool showCart;
  final bool enableNavigation;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    this.showFavorite = true,
    this.showCart = true,
    this.enableNavigation = true,
    this.onFavoriteToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndFavoriteStatus();
  }

  Future<void> _loadUserAndFavoriteStatus() async {
    final id = await UserSession.getUserId();
    final fav = await ApiFavorites.checkIfFavorite(id, widget.product.id);
    setState(() {
      userId = id;
      isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    final local = AppLocalizations.of(context)!;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.loginToContinue)),
      );
      return;
    }

    final added = await ApiFavorites.toggleFavorite(userId!, widget.product.id);
    setState(() => isFavorite = added);
    widget.onFavoriteToggle?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added ? local.addedToFavorites : local.removedFromFavorites,
        ),
        backgroundColor: added ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final local = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: widget.enableNavigation
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductScreen(product: widget.product),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    widget.product.image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                if (widget.showFavorite)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).cardColor,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                if (widget.showCart)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        await cartProvider.addToCart(widget.product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "🛒 ${widget.product.name} ${local.addedToCart}",
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).cardColor,
                        child: Icon(
                          Icons.shopping_cart,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.product.price} ر.س",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.product.rating > 0)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviews}K)",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
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
    );
  }
}
