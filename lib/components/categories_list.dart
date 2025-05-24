import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/colors.dart';
import '../model/categories_data.dart';
import '../services/api_categories.dart';
import '../screens/subcategories_screen.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiCategories.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                local.categoriesLoadError,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                local.categoriesEmpty,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final categories =
              snapshot.data!.where((cat) => cat.parentId == null).toList();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubcategoriesScreen(
                        mainCategory: category,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 36,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: ClipOval(
                              child: (category.imageUrl.trim().isEmpty ||
                                      category.imageUrl.trim() == 'https://')
                                  ? Image.asset(
                                      'assets/icon/B_MaxAll.png',
                                      fit: BoxFit.cover,
                                      width: 65,
                                      height: 65,
                                    )
                                  : Image.network(
                                      category.imageUrl,
                                      fit: BoxFit.cover,
                                      width: 65,
                                      height: 65,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/icon/B_MaxAll.png',
                                          fit: BoxFit.cover,
                                          width: 65,
                                          height: 65,
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
