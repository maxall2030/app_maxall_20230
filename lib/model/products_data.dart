// model/products_data.dart
class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String brand;
  final double rating;
  final int reviews;
  final int sold;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.sold,
    required this.quantity,
  });

  /// 🟢 `copyWith` لإنشاء نسخة معدلة من `Product`
  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? image,
    String? brand,
    double? rating,
    int? reviews,
    int? sold,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      sold: sold ?? this.sold,
      quantity: quantity ?? this.quantity, // ✅ تحديث الكمية عند الحاجة
    );
  }

  /// 🟢 تحويل JSON إلى كائن `Product`
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
      name: json["name"] ?? "منتج غير معروف",
      price: double.tryParse(json["price"]?.toString() ?? "0") ?? 0.0,
      image: json["image"]?.isNotEmpty == true
          ? json["image"]
          : "https://via.placeholder.com/150", // ✅ صورة افتراضية
      brand: json["brand"] ?? "ماركة غير معروفة",
      rating: double.tryParse(json["rating"]?.toString() ?? "0") ?? 0.0,
      reviews: int.tryParse(json["reviews"]?.toString() ?? "0") ?? 0,
      sold: int.tryParse(json["sold"]?.toString() ?? "0") ?? 0,
      quantity: int.tryParse(json["quantity"]?.toString() ?? "1") ??
          1, // ✅ الافتراضي 1
    );
  }

  /// 🟢 تحويل كائن `Product` إلى JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "name": name,
      "price": price.toString(),
      "image": image,
      "brand": brand,
      "rating": rating.toString(),
      "reviews": reviews.toString(),
      "sold": sold.toString(),
      "quantity": quantity.toString(),
    };
  }
}
