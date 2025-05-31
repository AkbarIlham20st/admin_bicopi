import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_model.dart';

class StockService {
  final supabase = Supabase.instance.client;

  Future<List<StockModel>> fetchStocks() async {
    final response = await supabase.from('menu_with_stok').select();
    print('[DEBUG] Response: $response');

    return (response as List).map((e) => StockModel.fromJson(e)).toList();
  }

  Future<void> updateStock({
    required int idStok,
    required int totalItem,
  }) async {
    final response = await supabase
        .from('stok_dapur')
        .update({'total_item': totalItem})
        .eq('id_stok', idStok)
        .select();

    if (response == null || response.isEmpty) {
      throw Exception('No row updated. Check idStok value.');
    }
  }

  Future<void> addNewStockItem({
    required String namaItem,
    required int totalItem,
    required String kategori,
  }) async {
    await supabase.from('stok_dapur').insert({
      'nama_item': namaItem,
      'total_item': totalItem,
      'kategori': kategori,
    });
  }
}