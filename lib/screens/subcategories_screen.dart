import 'package:flutter/material.dart';
import '../model/categories_data.dart';
import '../services/api_categories.dart';
import 'category_products_screen.dart';

class SubcategoriesScreen extends StatefulWidget {
  final Category mainCategory;

  const SubcategoriesScreen({super.key, required this.mainCategory});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  List<Category> allSubcategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
  }

  Future<void> _loadSubcategories() async {
    try {
      final response = await ApiCategories.getAllCategories();

      setState(() {
        allSubcategories = response
            .where((cat) => cat.parentId == widget.mainCategory.id)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("⚠️ خطأ أثناء جلب التصنيفات الفرعية: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.mainCategory.name),
        leading: const BackButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allSubcategories.isEmpty
              ? const Center(child: Text("لا توجد تصنيفات فرعية"))
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: allSubcategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final sub = allSubcategories[index];
                      return Material(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  category: sub,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: sub.imageUrl.trim().isEmpty
                                    ? Image.asset(
                                        'assets/icon/B_MaxAll.png',
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        sub.imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/icon/B_MaxAll.png',
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  sub.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
