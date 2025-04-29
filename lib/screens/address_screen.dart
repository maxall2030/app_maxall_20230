import 'package:flutter/material.dart';
import '../services/api_address.dart';
import '../model/addresses_data.dart';
import 'edit_address_screen.dart';
import 'add_address_screen.dart';
import '../utils/user_session.dart';
import '../constants/colors.dart'; // ✅ استيراد الألوان الثابتة

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address> addresses = [];
  bool isLoading = true;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await UserSession.getUserId();
    setState(() {
      userId = id;
    });
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      final fetched = await ApiAddress.fetchAddresses(userId);
      setState(() {
        addresses = fetched;
        isLoading = false;
      });
    } catch (e) {
      print("❌ خطأ في جلب العناوين: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAddressCard(Address address) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  "عنوان التوصيل",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${address.address}, ${address.city}, ${address.country}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone_android, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  address.phone ?? "غير متوفر",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  "أضيف في: ${address.createdAt.toString().split(' ').first}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditAddressScreen(address: address),
                      ),
                    );
                    if (result == true) fetchAddresses();
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("تعديل"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // تنفيذ الحذف لاحقاً
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text("حذف", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("عناويني"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? const Center(child: Text("لا توجد عناوين حالياً"))
              : ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) =>
                      _buildAddressCard(addresses[index]),
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddAddressScreen()),
            );
            if (result == true) fetchAddresses();
          },
          icon: const Icon(Icons.add_location_alt),
          label: const Text("إضافة عنوان جديد"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
