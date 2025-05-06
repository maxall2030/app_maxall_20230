import 'package:flutter/material.dart';
import 'package:app_maxall2/services/api_address.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/constants/colors.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool isLoading = false;

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final userId = await UserSession.getUserId();

    final success = await ApiAddress.addAddress(
      userId: userId,
      address: addressController.text,
      city: cityController.text,
      country: countryController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      // ✅ نعيد true لتحديث قائمة العناوين
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم إضافة العنوان بنجاح")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ فشل في إضافة العنوان")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة عنوان جديد"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("الدولة", countryController),
              _buildTextField("المدينة", cityController),
              _buildTextField("العنوان", addressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("حفظ العنوان",
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
