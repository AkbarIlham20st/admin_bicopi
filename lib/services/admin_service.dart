import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_model.dart';

class AdminService {
  final supabase = Supabase.instance.client;

  Future<List<AdminModel>> fetchAdmins() async {
    final response = await supabase.from('admins').select();

    return (response as List).map((json) => AdminModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'], role: '2',
    )).toList();
  }
}