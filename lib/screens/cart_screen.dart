import 'package:app_maxall2/screens/Orders/order_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../components/bottom_nav_bar.dart';
import 'package:app_maxall2/services/api_orders.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ إضافة ملف الألوان

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    userId = await UserSession.getUserId();
    Provider.of<CartProvider>(context, listen: false).fetchCart(userId);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🛒 سلة المشتريات"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text("🛒 سلتك فارغة، أضف منتجات للمتابعة."),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 360),
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartProvider.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Theme.of(context).cardColor,
                        child: Container(
                          height: 130,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "₪ ${product.price}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).hintColor),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red),
                                          onPressed: () =>
                                              cartProvider.updateQuantity(
                                                  product,
                                                  product.quantity - 1),
                                          iconSize: 20,
                                          padding: EdgeInsets.zero,
                                        ),
                                        Text("${product.quantity}",
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.green),
                                          onPressed: () =>
                                              cartProvider.updateQuantity(
                                                  product,
                                                  product.quantity + 1),
                                          iconSize: 20,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever,
                                        color: Colors.grey),
                                    onPressed: () =>
                                        cartProvider.updateQuantity(product, 0),
                                    iconSize: 22,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: buildCartSummary(
                    cartProvider.totalPrice,
                    cartProvider.cartItems.length,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }

  Widget buildCartSummary(double total, int itemCount) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow("المجموع الفرعي ($itemCount أصناف)",
                "₪ ${total.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            _buildSummaryRow("رسوم الشحن", "مجانا", isGreen: true),
            _buildSummaryRow("رسوم سوبر مول", "مجانا", isGreen: true),
            const Divider(height: 24),
            _buildSummaryRow(
              "المجموع",
              "₪ ${total.toStringAsFixed(2)}",
              isBold: true,
            ),
            const SizedBox(height: 6),
            const Text("شامل الضريبة", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: const [
                  Icon(Icons.percent, color: Colors.amber),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "تتوفر خطط أقساط شهرية للطلبات التي تزيد عن 200 ر.س.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () async {
                bool success = await ApiOrders.placeOrder(userId);
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderConfirmationScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("❌ فشل في تنفيذ الطلب. حاول مرة أخرى")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.arrow_back),
              label: Text(
                  "إتمام الشراء - ₪ ${total.toStringAsFixed(2)} ($itemCount صنف)"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isGreen = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15)),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 17 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isGreen ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}
