import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_model.dart';

class StockService {
  final supabase = Supabase.instance.client;

  Future<List<StockModel>> fetchStocks() async {
    final response = await supabase
        .from('menu')
        .select('id_menu, nama_menu, kategori, menu_stok(stok_dapur(id_stok, nama_item, total_item))');

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