import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<List<UserModel>> fetchUsers() async {
    final response = await supabase.from('users').select();

    return (response as List).map((json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      username: json['username'],
      password: json['password'],
      point: json['point'],
    )).toList();
  }
}
