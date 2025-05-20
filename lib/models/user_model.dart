class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String username;
  final String password;
  final int point;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.username,
    required this.password,
    required this.point,
  });
}

// models/admin_model.dart
class AdminModel {
  final String id;
  final String email;
  final String username;
  final String password;

  AdminModel({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
  });
}