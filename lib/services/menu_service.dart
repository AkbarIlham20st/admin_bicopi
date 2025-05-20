import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/menu_model.dart';

class MenuService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MenuModel>> fetchMenusByCategory(String category) async {
    final response = await _client
        .from('menu') // pastikan ini nama tabel di Supabase kamu
        .select()
        .eq('kategori', category)
        .order('created_at', ascending: false);

    final data = response;
    return (data as List)
        .map((menuJson) => MenuModel.fromJson(menuJson))
        .toList();
  }

  Future<void> addMenu(MenuModel menu) async {
    await _client.from('menu').insert(menu.toJson());
  }

  Future<void> updateMenu(String id, MenuModel menu) async {
    await _client
        .from('menu')
        .update(menu.toJson())
        .eq('id_menu', id);
  }

  Future<void> deleteMenu(String id) async {
    await _client.from('menu').delete().eq('id_menu', id);
  }
}
