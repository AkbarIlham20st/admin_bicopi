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

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
