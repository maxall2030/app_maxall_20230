import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/model/orders_model.dart';
import 'package:app_maxall2/model/profile.dart';
import 'package:app_maxall2/services/api_orders.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'dart:convert'; // ضروري لفك تشفير صورة المستخدم

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedFilter = "آخر 3 أشهر";
  List<String> filterOptions = ["آخر 3 أشهر", "آخر 6 أشهر", "آخر سنة"];
  List<Order> orders = [];
  bool isLoading = true;
  Profile? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserAndOrders();
  }

  Future<void> _loadUserAndOrders() async {
    final userId = await UserSession.getUserId();
    await _fetchUserProfile(userId);
    await fetchOrders(userId);
  }

  Future<void> _fetchUserProfile(int userId) async {
    try {
      final profile = await AuthService.getUserProfile(userId);
      if (profile != null) {
        setState(() {
          userProfile = profile;
        });
      }
    } catch (e) {
      print("⚠ خطأ في تحميل الملف الشخصي: $e");
    }
  }

  Future<void> fetchOrders(int userId) async {
    setState(() => isLoading = true);
    final months = selectedFilter.contains("3")
        ? 3
        : selectedFilter.contains("6")
            ? 6
            : 12;

    try {
      final fetched = await ApiOrders.fetchOrdersByDate(userId, months);
      setState(() {
        orders = fetched;
        isLoading = false;
      });
    } catch (e) {
      print("⚠ خطأ أثناء جلب الطلبات: $e");
      setState(() {
        orders = [];
        isLoading = false;
      });
    }
  }

  Widget _buildUserInfo() {
    if (userProfile == null) return const SizedBox.shrink();

    final String? localProfileImage = userProfile?.profileImage;

    final ImageProvider imageProvider =
        (localProfileImage != null && localProfileImage.isNotEmpty)
            ? MemoryImage(base64Decode(localProfileImage))
            : const AssetImage("assets/User.png") as ImageProvider;

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color.fromARGB(255, 240, 240, 250),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: imageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile!.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile!.email,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 10),
      appBar: AppBar(title: const Text("الطلبات"), centerTitle: true),
      body: Column(
        children: [
          _buildUserInfo(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  items: filterOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedFilter = value);
                      _loadUserAndOrders();
                    }
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "البحث عن المنتجات",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/empty_box.jpg", height: 160),
                          const SizedBox(height: 16),
                          const Text("لم يتم العثور على المنتجات",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              "لم نتمكن من العثور على أي منتجات تطابق بحثك في الفترة الزمنية المحددة",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return ListTile(
                            leading: const Icon(Icons.receipt_long_rounded,
                                color: Color.fromARGB(255, 71, 26, 232)),
                            title: Text("طلب #${order.id}"),
                            subtitle: Text(
                              "المبلغ: ₪${order.totalPrice.toStringAsFixed(2)} - الحالة: ${order.status}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: Text(
                              DateFormat('yyyy-MM-dd').format(order.createdAt),
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
