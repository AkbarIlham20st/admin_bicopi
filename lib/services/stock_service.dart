import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_model.dart';

class StockService {
  final supabase = Supabase.instance.client;

  Future<List<StockModel>> fetchStocks() async {
    final response = await supabase.from('menu_with_stok').select();
    print('[DEBUG] Response: $response');

    return (response as List).map((e) => StockModel.fromJson(e)).toList();
  }

  Future<void> addStock({
    required String idMenu,
    required String namaItem,
    required int totalItem,
  }) async {
    await supabase.from('stok_dapur').insert({
      'id_menu': idMenu,
      'nama_item': namaItem,
      'total_item': totalItem,
    });
  }
}