// model/categories_data.dart
class Category {
  final int id;
  final String name;
  final String imageUrl;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
  });

  /// 🟢 تحويل JSON إلى كائن `Category`
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"] ?? "فئة غير معروفة",
      imageUrl: json["image_url"] ??
          "https://www.notebookcheck.net/fileadmin/_processed_/webp/Notebooks/News/_nc4/Apple-iPhone-16-Pro-Max-Nachfolger-komplett-mit-drei-48-Megapixel-Kameras-q82-w480-h.webp",
      createdAt: json["created_at"] ?? "غير معروف",
    );
  }
}
