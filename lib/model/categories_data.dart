class Category {
  final int id;
  final String name;
  final String imageUrl;
  final String createdAt;
  final int? parentId; // ✅ حقل جديد لتحديد التصنيف الأب

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"] ?? "غير معروف",
      imageUrl: json["image_url"] ?? "",
      createdAt: json["created_at"] ?? "",
      parentId: json["parent_id"] != null
          ? int.tryParse(json["parent_id"].toString())
          : null,
    );
  }
}
