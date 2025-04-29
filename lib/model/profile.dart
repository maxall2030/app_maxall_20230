class Profile {
  int userId;
  String email;
  String name;
  String phone;
  String birthdate;
  String nationality;
  String gender;
  String address;
  String profileImage; // ✅ جديد

  Profile({
    required this.userId,
    required this.email,
    required this.name,
    required this.phone,
    required this.birthdate,
    required this.nationality,
    required this.gender,
    required this.address,
    required this.profileImage, // ✅ جديد
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json["id"] ?? 0,
      email: json["email"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      birthdate: json["birthdate"]?.toString() ?? "",
      nationality: json["nationality"]?.toString() ?? "",
      gender: json["gender"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      profileImage: json["profile_image"]?.toString() ?? "", // ✅ جديد
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "email": email,
      "name": name,
      "phone": phone,
      "birthdate": birthdate,
      "nationality": nationality,
      "gender": gender,
      "address": address,
      "profile_image": profileImage, // ✅ جديد
    };
  }
}
