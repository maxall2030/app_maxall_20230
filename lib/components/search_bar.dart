import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_maxall2/screens/search_screen.dart';
import 'package:app_maxall2/constants/colors.dart';

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
    final local = AppLocalizations.of(context)!;

    Widget searchField = TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: showBackButton,
      readOnly: !showBackButton,
      decoration: InputDecoration(
        hintText: local.searchHint,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
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
