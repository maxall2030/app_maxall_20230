// model/profile.dart
class Profile {
  int userId;
  String email;
  String firstName;
  String lastName;
  String phone;
  String birthdate;
  String nationality;
  String gender;
  String address;

  Profile({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthdate,
    required this.nationality,
    required this.gender,
    required this.address,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json["id"] ?? 0,
      email: json["email"]?.toString() ?? "",
      firstName: json["first_name"]?.toString() ?? "",
      lastName: json["last_name"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      birthdate: json["birthdate"]?.toString() ?? "",
      nationality: json["nationality"]?.toString() ?? "",
      gender: json["gender"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "birthdate": birthdate,
      "nationality": nationality,
      "gender": gender,
      "address": address,
    };
  }
}
