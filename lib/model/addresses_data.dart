// model/addresses_data.dart
class Address {
  final int id;
  final int userId;
  final String address;
  final String city;
  final String country;
  final String? firstName;
   final String? Name;
  final String? lastName;
  final String? phone;
  final DateTime createdAt;

  Address({
    required this.id,
    required this.userId,
    required this.address,
    required this.city,
    required this.country,
    this.Name,
    this.firstName,
    this.lastName,
    this.phone,
    required this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      address: json['address'] ?? "",
      city: json['city'] ?? "",
      country: json['country'] ?? "",
      firstName: json['first_name'],
      Name: json['name']??"",   // تأكد أنها موجودة في قاعدة البيانات
      lastName: json['last_name'],
      phone: json['phone'],
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    );
  }
}