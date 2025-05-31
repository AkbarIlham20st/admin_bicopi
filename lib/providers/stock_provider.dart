import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../services/stock_service.dart';

class StockProvider with ChangeNotifier {
  final StockService _service = StockService();
  List<StockModel> _stocks = [];

  List<StockModel> get stocks => _stocks;

  List<StockModel> getItemsByCategory(String category) {
    return _stocks.where((item) => item.category == category).toList();
  }

// Mencari item berdasarkan nama (case insensitive)
  StockItem? findStockItemByName(String namaItem) {
    for (final stok in _stocks) {
      for (final item in stok.menuStok) {
        if (item.namaItem.toLowerCase() == namaItem.toLowerCase()) {
          return item;
        }
      }
    }
    return null;
  }

// Menambahkan stok baru ke Supabase
  Future<void> addStockItem({
    required String namaItem,
    required int totalItem,
    required String kategori,
  }) async {
    try {
      await _service.addNewStockItem(
        namaItem: namaItem,
        totalItem: totalItem,
        kategori: kategori,
      );
      await fetchStocks(); // Refresh data
    } catch (e) {
      print('[ERROR] addStockItem: $e');
    }
  }

// Memperbarui total_item untuk id_stok tertentu
  Future<void> updateStockItem({
    required int idStok,
    required int totalItem,
  }) async {
    try {
      await _service.updateStock(
        idStok: idStok, // existing.idStok harus int, misal: 5
        totalItem: totalItem,
      );
      await fetchStocks(); // Refresh data
    } catch (e) {
      print('[ERROR] updateStockItem: $e');
    }
  }

// Ambil data stok awal dari Supabase
  Future<void> fetchStocks() async {
    try {
      final data = await _service.fetchStocks();
      _stocks = data;
      notifyListeners();
    } catch (e) {
      print('[ERROR] fetchStocks: $e');
    }
  }
}