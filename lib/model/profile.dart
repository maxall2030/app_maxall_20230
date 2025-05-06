class Profile {
  int id;
  String email;
  String name;
  String phone;
  String birthdate;
  String nationality;
  String gender;
  String address;
  String profileImage;

  Profile({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.birthdate,
    required this.nationality,
    required this.gender,
    required this.address,
    required this.profileImage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"] ?? 0,
      email: json["email"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      birthdate: json["birthdate"]?.toString() ?? "",
      nationality: json["nationality"]?.toString() ?? "",
      gender: json["gender"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      profileImage: json["profile_image"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "phone": phone,
      "birthdate": birthdate,
      "nationality": nationality,
      "gender": gender,
      "address": address,
      "profile_image": profileImage,
    };
  }
}
