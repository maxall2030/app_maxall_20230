import 'package:flutter/material.dart';
import 'package:app_maxall2/screens/search_screen.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ استيراد الثوابت

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool showBackButton;
  final VoidCallback? onBack;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.onChanged,
    this.showBackButton = false,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget searchField = TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: showBackButton,
      readOnly: !showBackButton, // ⛔ يمنع الكتابة في الصفحة الرئيسية
      decoration: InputDecoration(
        hintText: 'ابحث باسم المنتج...',
        hintStyle:
            TextStyle(color: AppColors.textSecondary), // ✅ لون النص الإرشادي
        prefixIcon: Icon(Icons.search,
            color: AppColors.textSecondary), // ✅ لون الأيقونة
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context)
            .scaffoldBackgroundColor, // ✅ لون الخلفية يتغير مع الثيم
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );

    return Row(
      children: [
        if (showBackButton)
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
        Expanded(
          child: showBackButton
              ? searchField
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                  child: AbsorbPointer(child: searchField),
                ),
        ),
      ],
    );
  }
}
