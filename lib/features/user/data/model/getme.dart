import 'dart:convert';

class Getme {
  int id;
  String name;
  String image;
  String phone;
  String email;
  String password;
  int isAdmin;
  DateTime createdAt;
  DateTime updatedAt;

  Getme({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  Getme copyWith({
    int? id,
    String? name,
    String? image,
    String? phone,
    String? email,
    String? password,
    int? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Getme(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
        isAdmin: isAdmin ?? this.isAdmin,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Getme.fromRawJson(String str) => Getme.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Getme.fromJson(Map<String, dynamic> json) => Getme(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    phone: json["phone"],
    email: json["email"],
    password: json["password"],
    isAdmin: json["is_admin"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "phone": phone,
    "email": email,
    "password": password,
    "is_admin": isAdmin,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
