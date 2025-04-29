import 'package:flutter/material.dart';
import '../model/addresses_data.dart';
import '../services/api_address.dart';
import '../constants/colors.dart'; // ✅ إضافة استدعاء الألوان الموحدة

class EditAddressScreen extends StatefulWidget {
  final Address address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController cityController;
  late TextEditingController fullAddressController;
  late TextEditingController countryController;

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController(text: widget.address.city);
    fullAddressController = TextEditingController(text: widget.address.address);
    countryController = TextEditingController(text: widget.address.country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل العنوان"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("معلومات الموقع"),
            _textField("العنوان الكامل", fullAddressController),
            _textField("المدينة", cityController),
            _textField("الدولة", countryController),
            const Divider(height: 30),
            _sectionTitle("معلوماتك الشخصية"),
            _readOnlyText("الاسم",
                "${widget.address.Name ?? ''} ${widget.address.lastName ?? ''}"),
            _readOnlyText("رقم الجوال", widget.address.phone ?? "غير متوفر"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "حفظ التعديلات",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color ??
            AppColors.textSecondary,
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _readOnlyText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAddress() async {
    final success = await ApiAddress.updateAddress(
      id: widget.address.id,
      address: fullAddressController.text,
      city: cityController.text,
      country: countryController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم حفظ التعديلات بنجاح")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ حدث خطأ أثناء حفظ التعديلات")),
      );
    }
  }
}
