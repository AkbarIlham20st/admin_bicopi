class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String username;
  final String password;
  final int point;
  final String role; // Tambahkan ini

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.username,
    required this.password,
    required this.point,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      username: json['username'],
      password: json['password'],
      point: json['point'],
      role: json['role'], // Ambil dari Supabase
    );
  }
}


